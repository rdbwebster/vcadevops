#!/bin/bash

### Create VApps for devops demo on vCloud Air using vca-cli 
### Must set VCA_PASS  env variable before running script
### Must set local settings in config.json file before running script

# Read settings from config.json file

export VCA_USER=($(jq -r '.VCA_USER' config.json)); echo VCA_USER = ${VCA_USER}
export VCA_VDC=($(jq -r '.VCA_VDC' config.json)); echo VCA_VDC = $VCA_VDC
export VCA_INSTANCE=($(jq -r '.VCA_INSTANCE' config.json)); echo VCA_INSTANCE = $VCA_INSTANCE
export UBUNTU_PRIVATE_KEY=($(jq -r '.VCA_USER' config.json)); echo UBUNTU_PRIVATE_KEY = $UBUNTU_PRIVATE_KEY
export VCA_PUBLIC_IP=($(jq -r '.VCA_PUBLIC_IP' config.json)); echo VCA_PUBLIC_IP = $VCA_PUBLIC_IP

if [ -z ${VCA_PASS+x} ]; then
    echo "VCA_PASS must be set as environment variable"
    exit;
fi

if [ ! -f ${UBUNTU_PRIVATE_KEY} ]; then echo "The specified private key file does not exist"; fi

### Login to vCloud Air

echo "Logging into vCloud Air"

# Fail this script on command error
set -e

echo Using vca-cli $(vca --version)

#OnDemand
echo "Logging into vCloud Air"
vca login $VCA_USER --password "$VCA_PASS" --instance $VCA_INSTANCE --vdc $VCA_VDC


###
### devops Server
###

# Create devops Server vApp if it does not already exist

if [ $(vca vapp list | grep devopsApp | wc -l) -eq 0 ]
then
  vca vapp create -a devopsApp -V devops -c 'Public Catalog' -t 'Ubuntu Server 12.04 LTS (amd64 20150127)' -n default-routed-network -m pool --cpu 2 --ram 4096
  vca vapp customize --vapp devopsApp --vm devops --file ./customization.sh

  echo initial user ubuntu with password $(vca vapp info --vapp devopsApp | grep "admin_password" |  cut -d'|' -f4)
else
 echo Devops vApp exists
fi

# Get and Save ip
export devops_server_ip=$(./wait_boot_ip.sh devopsApp devopsApp)
echo Devops server at ip ${devops_server_ip}

# Add a SNAT rule for the Network if it does not already exist
export SNAT_RULE=$(vca -j nat  | jq --arg public_ip "$VCA_PUBLIC_IP" '."nat-rules"[] | select(."Translated IP"==$public_ip) | select(.Type=="SNAT")')
if [ ! "${SNAT_RULE}" ]; then
   
   vca nat add --type SNAT --original-ip 192.168.109.0/24 --translated-ip $VCA_PUBLIC_IP
fi
# Setup Nat rule for ssh access
export DNAT_RULE1=$(vca -j nat  | jq --arg public_ip "$PUBLIC_IP" '."nat-rules"[] | select(."Translated IP"==$public_ip) | select(.Type=="DNAT")')
if [ ! "${DNAT_RULE2}" ]; then 
   echo "DNAT rule already defined for $VCA_PUBLIC_IP, skipping"
else
  echo adding NAT rule to gateway for ssh
  vca nat add --type DNAT  --original-ip $VCA_PUBLIC_IP  --original-port 22 --translated-ip ${devops_server_ip} --translated-port 22 --protocol tcp

  echo adding NAT rule for Jenkins http to gateway
  vca nat add --type DNAT  --original-ip $VCA_PUBLIC_IP  --original-port 8100 --translated-ip ${devops_server_ip} --translated-port 8100 --protocol tcp

# Gitlab Removed 01/2016
#  echo adding NAT rule for Gitlab  http to gateway
#  vca nat add --type DNAT  --original-ip $VCA_PUBLIC_IP  --original-port 8300 --translated-ip ${devops_server_ip} --translated-port 8300 --protocol tcp

  echo adding NAT rule for nginx  http to gateway
  vca nat add --type DNAT  --original-ip $VCA_PUBLIC_IP  --original-port 80 --translated-ip ${devops_server_ip} --translated-port 80 --protocol tcp

  echo adding NAT rule for Artifactory http to gateway
  vca nat add --type DNAT  --original-ip $VCA_PUBLIC_IP  --original-port 8081 --translated-ip ${devops_server_ip} --translated-port 8081 --protocol tcp

  echo adding NAT rule for Selenium  http to gateway
  vca nat add --type DNAT  --original-ip $VCA_PUBLIC_IP  --original-port 4444 --translated-ip ${devops_server_ip} --translated-port 4444 --protocol tcp

  echo adding NAT rule for redirect to iptables for routing through devops server
  vca nat add --type DNAT  --original-ip $VCA_PUBLIC_IP  --original-port ANY --translated-ip ${devops_server_ip} --translated-port ANY --protocol tcp
fi

# Add the private key to the ubuntu server so it can ssh to other servers created by jenkins
scp -i ${UBUNTU_PRIVATE_KEY} ${UBUNTU_PRIVATE_KEY} ubuntu@$VCA_PUBLIC_IP:~/.ssh/id_rsa
ssh -o 'StrictHostKeyChecking=no' -i ${UBUNTU_PRIVATE_KEY}  ubuntu@$VCA_PUBLIC_IP "chmod 700 ~ubuntu/.ssh/ubuntu_rsa > log.out 2> log.err < /dev/null &"


###
### Chef Server
###

# Create Chef Server vApp if it does not already exist

if [ $(vca vapp list | grep chefServerApp | wc -l) -eq 0 ]
then

 echo "Creating Chef vApp"
 vca vapp create -a chefServerApp -V chefServer -c 'Public Catalog' -t 'Ubuntu Server 12.04 LTS (amd64 20150127)' --cpu 2 --ram 4096 -n default-routed-network -m pool

 vca vapp customize --vapp chefServerApp --vm chefServer --file ./customization.sh
 echo initial user ubuntu with password $(vca vapp info --vapp chefServerApp | grep "admin_password" |  cut -d'|' -f4)
else
 echo chefServerApp vApp exists
fi

# Get and Save ip
export chef_server_ip=$(./wait_boot_ip.sh chefServerApp chefServer)
echo Chef server at ip ${chef_server_ip}


# Setup Nat rule for ssh access
export DNAT_RULE2=$(vca -j nat  | jq --arg public_ip "$PUBLIC_IP" '."nat-rules"[] | select(."Translated IP"==$public_ip) | select(.Type=="DNAT")')
if [ ! "${DNAT_RULE2}" ]; then 
   echo "DNAT rule already defined for $VCA_PUBLIC_IP, skipping"
else
  echo adding ssh NAT rule to gateway
  vca nat add --type DNAT  --original-ip $VCA_PUBLIC_IP --original-port 33 --translated-ip ${chef_server_ip} --translated-port 22 --protocol tcp
  echo adding http NAT rule for chef http to gateway
  vca nat add --type DNAT  --original-ip $VCA_PUBLIC_IP --original-port 8200 --translated-ip ${chef_server_ip} --translated-port 8200 --protocol tcp

  echo adding ssh NAT rule to gateway for chef redirect
  vca nat add --type DNAT  --original-ip $VCA_PUBLIC_IP --original-port 8200 --translated-ip  ${chef_server_ip} --translated-port 8200 --protocol tcp -n d2p3v40-ext

  echo adding http NAT rule for chef https to gateway
  vca nat add --type DNAT  --original-ip $VCA_PUBLIC_IP --original-port 443 --translated-ip ${chef_server_ip} --translated-port 443 --protocol tcp

  echo add Additional DNAT rule to internal network rule for chef knife bootstrap callout (hairpin nat)
  vca nat add --type dnat  --original-ip $VCA_PUBLIC_IP --original-port ANY --translated-ip ${chef_server_ip} --translated-port ANY --protocol tcp  --network default-routed-network

  echo add Additional SNAT rule to internal network rule for chef knife bootstrap callout (hairpin nat)
  vca nat add --type snat  --original-ip 192.168.109.0/24 --original-port ANY --translated-ip $VCA_PUBLIC_IP --translated-port ANY --protocol tcp  --network default-routed-network
fi


# Add an entry to devops server hosts file that points to chef server
# use tee for sudo append
ssh -o 'StrictHostKeyChecking=no' -i ${UBUNTU_PRIVATE_KEY}  ubuntu@$VCA_PUBLIC_IP "echo "${chef_server_ip} chef.vcair.us chef" | sudo tee -a /etc/hosts"

# Add an entry to chef server hosts file that points to devops server
# use tee for sudo append
ssh -o 'StrictHostKeyChecking=no' -i ${UBUNTU_PRIVATE_KEY} -p33  ubuntu@$VCA_PUBLIC_IP "echo "${devops_server_ip} devops.vcair.us devops" | sudo tee -a /etc/hosts"

