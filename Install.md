## Install Desktop Env


This document details how to setup a developer workstation operating outside of vCloud Air.
The workstation would be used to demonstrate the single developer use case, 
it is not required for the team CI demo.


#### Mac Setup Steps

// install chef sdk on mac


[https://downloads.chef.io/chef-dk/mac/#/](https://downloads.chef.io/chef-dk/mac/#/)

```
wget https://opscode-omnibus-packages.s3.amazonaws.com/mac_os_x/10.8/x86_64/chefdk-0.4.0-1.dmg

// double click dmg to mount as a device, run installer.

```



#### Install Knife-Solo

Knife solo: provides a set of convenience commands on top of chef-solo
[http://matschaffer.github.io/knife-solo](http://matschaffer.github.io/knife-solo/)

```
$ gem install knife-solo

```




#### Install VCA-CLI on mac

[https://github.com/vmware/vca-cli](https://github.com/vmware/vca-cli)


```
$ sudo pip install virtualenv

$ cd ~
$ virtualenv pythonenv
$ cd pythonenv
$ source bin/activate

$ python -V
  Python 2.7.5

// Get a specific version of vca-cli not the production version.
$ pip install vca-cli==10rc8

// check version, should be same as below
# vca --version
  vca-cli version 10rc8 (pyvcloud: 12rc4)

```




#### Generate public keys for the ubuntu user

The VMs we create will have SSH keys installed so that the ubuntu user can ssh into the server.
This is a good security practice, but primarily done since currently vca-cli does not have the 
ability to set the default password for root when creating a VM.  Using the SSH key is better 
than having to login the VCloud Director UI and lookup the generated password for root.
But that is an additional option to access the server if needed.

```
// this creates keys in current folder, don't supply a pwsd

$ ssh-keygen -t rsa -f ./ubuntu_rsa
```

We supply a guest customization script to the VM when it is created.
The script adds the SSH key and also configures a DNS Nameserver which is needed for the Chef Bootstrap
command to succeed.


#### Create customization file for vm using template below

// Replace the key value string below with the value in ubuntu_rsa.pub file you just created above.

```
vi customize.sh

 #!/bin/bash
  echo performing customization tasks with param $1 at `date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"` >> /root/customization.log
  if [ x$1=x"precustomization" ];
  then
    echo performing precustomization tasks on `date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"`
    echo performing precustomization tasks on `date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"` >> /root/customization.log
  fi
  if [ x$1=x"postcustomization" ];
  then
    echo performing postcustomization tasks at `date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"`
    mkdir -p /home/ubuntu/.ssh

    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDnD0tFDxOGD9O9gcaXD/2g1btxqjww8g6aPoc4RumbqwAvR4EYDQXkPrL08xGcLZttieSf+c3q6ZL4Vu7cDg+79/lbtZFk4f552+syhz27NUzPUMcSIdTL4PjDJv523WV6C+Jen9BadwhkyxwcQhU3nmwjkv+euHrxk03PtSiEBJTNMgQdsxw4fndA/9Pqh2TSShRUtEIbY35wQt0mxpvomANLTtR2nxuzWS1GQY69um0mR26++x33E5ylQOr2eiJO++73V+IZxgjRY06vQSUKZGc64H3BJlX2BKmABbV3sVji82mmkDyFK3yX538WRwUbvmuGSbVfiyKTIs7UK21f bwebster@bwebster-mbpro.local' >> /home/ubuntu/.ssh/authorized_keys

    chown ubuntu.ubuntu /home/ubuntu/.ssh
    chown ubuntu.ubuntu /home/ubuntu/.ssh/authorized_keys
    chmod go-rwx /home/ubuntu/.ssh
    chmod go-rwx /home/ubuntu/.ssh/authorized_keys

    printf "nameserver 8.8.8.8 \n" >> /etc/resolvconf/resolv.conf.d/base


    echo performing postcustomization tasks at `date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"` >> /root/customization.log
  fi

```