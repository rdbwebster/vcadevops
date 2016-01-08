
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

==== RUN PROVISIONING

// You must Set the environment variables in config.json

// You must set VCA_PASS as an environment variable to access the target vCloud Air VDC

// You must set JENKINS_PASS as an environment variable to set the default password for the Jenkins admin user.

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

Login using browser with jenkins / YourPswd

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


Setup Jenkins Hook from Github

    Go to https://github.com/vcadevops/word-finder > Settings > Webhooks & Services > Services > Add a Service > Jenkins (Github plugin)

    Jenkins hook url: http://devops.vcair.us:8100/github-webhook/

    Be sure Active is checked and click Add Service



Artifactory: Post Provisioning Step
Login to artifactory using 
admin / password

Security->Users
to admin / yourpassword

Anonymous users (not logged in) can browse by default.
