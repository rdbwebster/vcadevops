#!/bin/bash

### Create VApps for devops demo on vCloud Air using vca-cli 

### Must set VCA_PASSWORD env variable before running script

if [ -z ${VCA_PASSWORD+x} ]; then echo "VCA_PASSWORD env variable must be set"; fi


### Login to vCloud Air

echo "Logging into vCloud Air"
vca login --password ${VCA_PASSWORD:?must be set in env} --host vchs.vmware.com --type subscription --version 5.6 --org M933009684-4424 vcadevops@gmail.com

vca org use --org M933009684-4424 --service M933009684-4424

###
### Chef Server
###

# Create Chef Server vApp

if [ $(vca vapp list | grep chefServerApp | wc -l) -eq 0 ]
then

 echo "Creating Chef vApp"
 vca vapp create -a chefServerApp -V chefServer -c 'Public Catalog' -t 'Ubuntu Server 12.04 LTS (amd64 20150127)' -n M933009684-4424-default-routed -m POOL

 vca vapp customize --vapp chefServerApp --vm chefServer --file ./customization.sh
else
 echo chefServerApp vApp exists
fi

# Get and Save ip
export chef_server_ip=$(./wait_boot_ip.sh chefServerApp chefServer)
echo created chef server at ip ${chef_server_ip}

# Setup Nat rule for ssh access
if [ $(vca nat list | grep 23.92.225.229 | grep DNAT | cut -d'|' -f6) -eq 33 ] 
then
   echo "Warning: Nat rule already defined for 23.92.225.229 port 33"
else
  echo adding NAT rule to gateway
  vca nat add --type DNAT  --original-ip 23.92.225.229 --original-port 33 --translated-ip ${chef_server_ip} --translated-port 22 --protocol any
fi


###
### devops Server
###

# Create devops Server vApp

if [ $(vca vapp list | grep devopsApp | wc -l) -eq 0 ]
then
  vca vapp create -a devopsApp -V devops -c 'Public Catalog' -t 'Ubuntu Server 12.04 LTS (amd64 20150127)' -n M933009684-4424-default-routed -m POOL
  vca vapp customize --vapp devopsApp --vm devops --file ./customization.sh

else
 echo chefServerApp vApp exists
fi

# Get and Save ip
export devops_server_ip=$(./wait_boot_ip.sh devopsApp devopsApp)
echo Created devops server at ip ${devops_server_ip}

# Setup Nat rule for ssh access
if [ $(vca nat list | grep 23.92.225.229 | grep DNAT | cut -d'|' -f6) -eq 22 ] 
then
   echo "Warning: Nat rule already defined for 23.92.225.229 port 22"
else
  echo adding NAT rule to gateway
  vca nat add --type DNAT  --original-ip 23.92.225.229 --original-port 22 --translated-ip ${chef_server_ip} --translated-port 22 --protocol any
fi


