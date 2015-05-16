if [ "$#" -ne 3 ];
    then echo "Usage: set_host_name hostip oldhostname newhostname"
    exit
fi

# Clear previous host keys if any
ssh-keygen -R $2
ssh-keygen -R $3

# Get the host keys for the server to avoid runtime prompt
# Safer than ssh -o 'StrictHostKeyChecking=no'
ssh-keyscan -t rsa1,rsa,dsa $1 >> ~/.ssh/known_hosts

# set hostname until restart for immediate effect
ssh  ubuntu@$1 "sudo /bin/hostname $3"

# Backup /etc/hosts file
ssh ubuntu@${1} "sudo cp /etc/hosts /etc/hosts.$(date -d "today" +"%Y%m%d%H%M")"

# change hostname for after restart
# Double quotes so shell expands positional variables
#ssh ubuntu@$1 "sudo sed "/^127\.0\.1\.1/s/'${2}'/'${3}'/g" -i  /etc/hosts  | sudo tee --append  /etc/hosts "
ssh ubuntu@$1 "sudo sed "s/${2}/${3}/g" -i /etc/hosts"

# set hostname
ssh ubuntu@$1  "echo $3 | sudo tee /etc/hostname"
