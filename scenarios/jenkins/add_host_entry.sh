if [ "$#" -ne 2 ];
    then echo "Usage: add_host_entry ip hostname"
    exit
fi

# Backup /etc/hosts
sudo cp /etc/hosts  /etc/hosts.$(date -d "today" +"%Y%m%d%H%M")

# Delete the entry if it exists
sed  '/'$1'/d' -i  /etc/hosts | sudo tee --append /etc/hosts

# Add entry
echo "${1}     ${2}" | sudo tee --append /etc/hosts
