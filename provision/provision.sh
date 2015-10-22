#!/bin/bash

### Provision devops demo on vCloud Air using ansible

### Must set VCA_PASS env variable before running script

### Abort if shell command returns error
set -e

### Set no host checking 
export ANSIBLE_HOST_KEY_CHECKING=False

export VCA_USER=($(jq -r  '.VCA_USER' config.json)); echo $VCA_USER
export VCA_VDC=($(jq  -r '.VCA_VDC' config.json)); echo $VCA_VDC
export VCA_INSTANCE=($(jq  -r '.VCA_INSTANCE' config.json)); echo $VCA_INSTANCE
export UBUNTU_PRIVATE_KEY=($(jq  -r '.UBUNTU_PRIVATE_KEY' config.json)); echo $UBUNTU_PRIVATE_KEY
export VCA_PUBLIC_IP=($(jq  -r '.VCA_PUBLIC_IP' config.json)); echo $VCA_PUBLIC_IP

if [ -z ${VCA_PASS+x} ]; then
    echo "VCA_PASS must be set as environment variable"
    exit;
fi

if [ ! -f ${UBUNTU_PRIVATE_KEY} ]; then echo "The specified private key file ${UBUNTU_PRIVATE_KEY} does not exist"; fi

export ANSIBLE_HOSTS=./hosts

# get new host keys to avoid possible host validation error when doing ssh
#ssh-keyscan -t rsa1,rsa,dsa 23.92.225.229 >> ~/.ssh/known_hosts

ssh-keygen -R $VCA_PUBLIC_IP
ssh-keygen -R [${VCA_PUBLIC_IP}]:33

### Login to onDemand vCloud Air

echo "Logging into vCloud Air"
vca login $VCA_USER --password "$VCA_PASS" --instance $VCA_INSTANCE --vdc $VCA_VDC

### Create the Servers

./create_servers.sh

# Get and Save devops Server ip
export devops_server_ip=$(./wait_boot_ip.sh devopsApp devopsApp)
echo devops_server_ip=${devops_server_ip}

###
### Generate Ansible hosts file 
###

echo devops ansible_ssh_port=22 ansible_ssh_host=${VCA_PUBLIC_IP} > hosts
echo chef   ansible_ssh_port=33 ansible_ssh_host=${VCA_PUBLIC_IP} >> hosts

###
### Provision Chef Server
###

# Get and Save ip
export chef_server_ip=$(./wait_boot_ip.sh chefServerApp chefServer)
echo chef_server_ip=${chef_server_ip} 

# Provision Chef Server
echo Provision chef server
ansible-playbook  playbook_chefServer.yml -u ubuntu --private-key   ${UBUNTU_PRIVATE_KEY}  --sudo


###
### Provision DevOps Server
###

# Provision Devops Server after Chef Server so connection to chef can be configured
echo Provision devops server
ansible-playbook  playbook_devopsServer.yml -i ./hosts -u ubuntu --private-key  ${UBUNTU_PRIVATE_KEY} --sudo

