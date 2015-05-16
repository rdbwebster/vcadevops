if [ "$#" -ne 3 ];
    then echo "Usage: set_host_name hostip oldhostname newhostname"
    exit
fi

# set hostname until restart for immediate effect

ssh ubuntu@$1 sudo hostname $3

# change hostname for after restart

ssh ubuntu@$1 sudo sed '/^127\.0\.1\.1/s/'$2'/'$3'/g' -i  /etc/hosts  | sudo tee  /etc/hosts 

ssh ubuntu@$1  "echo $3 | sudo tee /etc/hostname"
