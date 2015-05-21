
This folder contains ansible scripts to provision the vca devops demo



Recommended Environment setup

```
// Install python virtual env and dependencies

$ sudo apt-get install -y build-essential libssl-dev libffi-dev libxml2-dev libxslt-dev python-dev 

// Install pip with easy-install to avoid 'cannot import name IncompleteRead' Error
$ sudo easy_install -U pip

// Create a python virtual enhv

$ virtualenv vcadevopsenv

// Check out the vcadevops project into this folder

$ git clone https://github.com/rdbwebster/vcadevops.git

// activate the virtual env

$ source bin/activate

// install vca-cli

$ pip install vca-cli==10rc8

```

// Set the environment variables

export VCA_PASSWORD='your vcloud air user id password'
export UBUNTU_PRIVATE_KEY=~/.ssh/ubuntu_rsa


// Run the create server script

// Note!!
// The create_server script creates the vapps and add NAT rules using vca-cli but there are issues.
// The NAT rule configuration fails, so the rules must be added through the vcloud air console.
// The server created for ChefServer is too small, after creation, 
// stop and reconfigure both VM's through the vcloud air 
// console 
// Set both servers to 2 cpu, 4 GB Ram, 16 GB Disk

./create_server.sh

// Run the provision script

./provision.sh

