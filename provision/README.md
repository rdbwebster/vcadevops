
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


// POST PROVISION STEPS



Jenkins
------

> Secure Jenkins

Goto jenkins url http://devops.vcloudair.io:8100
Click on - Manage Jenkins  (on left side of page)
Click on - Configure System or watch for Setup Security button on right 

Check - Enable Security
      - Jenkins Own User Database  + allow users to sign up
      - Anyone can do anything
Save this page

Then on main page click - Sign up - and add a new user admin or jenkins/ passwd_as_whateveryouwant


Then go back into Manage Jenkins / Configure Jenkins and check
      - UNCHECK Allow users to sign up

Login using browser with jenkins / devops123

Then check matrix based security
Add a jenkins or admin user
check all boxes for jenkins/admin
For anonymous user check
Overall Read
Job Discover
Job Extended Read (requires Hudson Extended Read plugin)
Discover
Note:// if this does not work, and you are locked out, shut off security in the jenkins config file
vi /var/lib/jenkins/config.xml  
// change useSecurity to false
service jenkins restart

Confirm all plugins are installed.
API plugin installation is not reliable.
You must confirm all plugins loaded and manually load any if missing.
The reload all jobs since sections in jobs that reference missing plugins will have been dropped.



> Set bash as default shell 
In console -> Manage Jenkins -> Configure System
In Shell Section 
Set Shell executable field to 
/bin/bash


GitLab
------
> Login to Gitlab and change password

Username: root
Password: 5iveL!fe

Default Username: root
Default Password: 5iveL!fe
change to your choice of password

>Checkin wordfinder project
- helpful notes here https://git-scm.com/book/en/v2/Git-on-the-Server-GitLab

First login to gitlab console, click create new Project
Add a project named word-finder, check the public radio button.

Next, Login to devops server as ubuntu using terminal

cd /Users/bwebster/apps/vcadevopsenv/vcadevops/scenarios/wordFinder/word-finder

git remote add gitlab http://vcair.us:8300/root/word-finder.git

git remote -v

git push gitlab  master

supply  root/ password you set above for root as creds


Setup Jenkins Hook from Github

    Go to https://github.com/vcadevops/word-finder > Settings > Webhooks & Services > Services > Add a Service > Jenkins (Github plugin)

    Jenkins hook url: http://devops.vcair.us:8100/github-webhook/

    Be sure Active is checked and click Add Service

