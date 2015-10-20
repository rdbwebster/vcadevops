#!/bin/bash

### Provision Chef Server 12 for devops demo on vCloud Air using vca-cli and ansible

### Must set VCA_PASSWORD env variable before running script
### Must set UBUNTU_PRIVATE_KEY env variable to point to location of ubuntu private key file

if [ -z ${VCA_PASSWORD+x} ]; then echo "VCA_PASSWORD env variable must be set"; fi
if [ -z ${UBUNTU_PRIVATE_KEY+x} ]; then echo "UBUNTU_PRIVATE_KEY env variable must be set"; exit 1; fi
if [ ! -f ${UBUNTU_PRIVATE_KEY} ]; then echo "The specified private key file does not exist"; fi

export ANSIBLE_HOSTS=./hosts

// get new host keys to avoid possible host validation error when doing ssh

#ssh-keyscan -t rsa1,rsa,dsa 23.92.225.229 >> ~/.ssh/known_hosts

ssh-keygen -R ${VCA_PUBLIC_IP}
ssh-keygen -R [${VCA_PUBLIC_IP}]:33

### Login to vCloud Air

#echo "Logging into vCloud Air"
#vca login --password ${VCA_PASSWORD:?must be set in env} --host vchs.vmware.com --type subscription --version 5.6 --org M933009684-4424 vcadevops@gmail.com

#vca org use --org M933009684-4424 --service M933009684-4424

###
### Chef Server
###

# Get and Save ip
#export chef_server_ip=$(./wait_boot_ip.sh chefServerApp chefServer)
#echo chef_server_ip=${chef_server_ip} 

# Provision Chef Server
echo Provision chef server
ansible-playbook  playbook_chefServer.yml -u ubuntu --private-key   ${UBUNTU_PRIVATE_KEY}  --sudo



