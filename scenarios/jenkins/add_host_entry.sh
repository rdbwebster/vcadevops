if [ "$#" -ne 2 ];
    then echo "Usage: add_host_entry ip hostname"
    exit
fi

# Delete the entry if it exists
sed  '/'$1'/d' -i  /etc/hosts | sudo tee --append /etc/hosts

# Add entry
echo "${1}     ${2}" | sudo tee --append /etc/hosts
