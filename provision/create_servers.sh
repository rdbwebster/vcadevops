#!/bin/bash

### Create VApps for devops demo on vCloud Air using vca-cli 

### Must set VCA_PASS env variable before running script

if [ -z ${VCA_PASS+x} ]; then echo "VCA_PASS env variable must be set"; fi

### Login to vCloud Air

echo "Logging into vCloud Air"
# Subsctiption
#vca login --password ${VCA_PASS:?must be set in env} --host vchs.vmware.com --type subscription --version 5.6 --org M933009684-4424 vcadevops@gmail.com
#vca org use --org M933009684-4424 --service M933009684-4424

# Existing Public Gateway IP to use
export PUBLIC_IP=23.92.254.205

# Fail this script on command error
set -e

echo Using vca-cli $(vca --version)

#OnDemand
vca login appstech@websterx.com --password "$VCA_PASS" --instance 97453e02-e83c-4cae-bbe9-3f7ee6dd8401 --vdc VCD-DevOps


###
### Chef Server
###

# Create Chef Server vApp

if [ $(vca vapp list | grep chefServerApp | wc -l) -eq 0 ]
then

 echo "Creating Chef vApp"
 vca vapp create -a chefServerApp -V chefServer -c 'Public Catalog' -t 'Ubuntu Server 12.04 LTS (amd64 20150127)' -n default-routed-network -m POOL

 vca vapp customize --vapp chefServerApp --vm chefServer --file ./customization.sh
else
 echo chefServerApp vApp exists
fi

# Get and Save ip
export chef_server_ip=$(./wait_boot_ip.sh chefServerApp chefServer)
echo created chef server at ip ${chef_server_ip}

# Add a SNAT rule for the Network if it does not already exist
export SNAT_RULE=$(vca -j nat  | jq --arg public_ip "$PUBLIC_IP" '."nat-rules"[] | select(."Translated IP"==$public_ip) | select(.Type=="SNAT")')
if [ ! "${SNAT_RULE}" ]; then
   
   vca nat add --type SNAT --original-ip 192.168.109.0/24 --translated-ip $PUBLIC_IP
fi

# Setup Nat rule for ssh access
if [ $(vca nat list | grep $PUBLIC_IP | grep DNAT | cut -d'|' -f6) -eq 33 ] 
then
   echo "Warning: Nat rule already defined for $PUBLIC_IP  port 33"
else
  echo adding NAT rule to gateway
  vca nat add --type DNAT  --original-ip $PUBLIC_IP --original-port 33 --translated-ip ${chef_server_ip} --translated-port 22 --protocol tcp
fi


###
### devops Server
###

# Create devops Server vApp

if [ $(vca vapp list | grep devopsApp | wc -l) -eq 0 ]
then
  vca vapp create -a devopsApp -V devops -c 'Public Catalog' -t 'Ubuntu Server 12.04 LTS (amd64 20150127)' -n default-routed-network -m POOL
  vca vapp customize --vapp devopsApp --vm devops --file ./customization.sh

else
 echo chefServerApp vApp exists
fi

# Get and Save ip
export devops_server_ip=$(./wait_boot_ip.sh devopsApp devopsApp)
echo Created devops server at ip ${devops_server_ip}

# Setup Nat rule for ssh access
if [ $(vca nat list | grep $PUBLIC_IP | grep DNAT | cut -d'|' -f6) -eq 22 ] 
then
   echo "Warning: Nat rule already defined for $PUBLIC_IP port 22"
else
  echo adding NAT rule to gateway
  vca nat add --type DNAT  --original-ip $PUBLIC_IP  --original-port 22 --translated-ip ${chef_server_ip} --translated-port 22 --protocol tcp
fi


