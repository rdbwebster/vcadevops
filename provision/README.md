
This folder contains ansible and vca-cli scripts to provision the vca devops demo



Recommended Environment setup

```
// Install python virtual env and dependencies

$ sudo apt-get install -y build-essential libssl-dev libffi-dev libxml2-dev libxslt-dev python-dev 

// Install pip with easy-install to avoid 'cannot import name IncompleteRead' Error
$ sudo easy_install -U pip

// Create a python virtual env

$ virtualenv vcadevopsenv

// Check out the vcadevops project into this folder

$ git clone https://github.com/rdbwebster/vcadevops.git

// activate the virtual env

$ source bin/activate

// install vca-cli

$ pip install vca-cli==10rc8

```

// You must Set the environment variables in config.json

// You mus also set VCA_PASS as an environment variable

// Run the provision script to create servers and provision

./provision.sh


// This will call create_servers.sh and have vca-cli create devops and chef servers
// It will configure the GW for ssh access using a defined ubuntu key
// It will then call Ansible to provision the Chef Server
// It will then call Ansible to provision the Devops Server

// for partial processing of just one server use the run_playbook_chefServer.sh
// and the run_playbook_devopsServer.sh
