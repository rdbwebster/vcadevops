
## Devops with vCloud Air Demo

###  An individual Developer

![WebSnapshot](https://github.com/rdbwebster/vcadevops/blob/master/images/devop1.png)


In this first case we consider an individual developer who has existing cookbooks and application assets and would like to deploy the application to a configured Virtual Machine on vCloud Air.  The OS template may be a stock template provided by vmware or a custom gold template provided by the enterprise.

The developer is working from a workstation and is not part of a team leveraging a Chef Server for configuration management.
The developer maintains the application code and chef recipes in a version control system.

The developer will utilize the vcloud air cli to create the vm and configure the network,  and Chef-solo to do the provisioning and application deployment.


###### Login to vCloud Air and create a customized virtual machine

```
vca login org1@websterx.com --password $PASSWORD --host vchs.vmware.com --type subscription --version 5.6 --org M933009684-4424
vca org use --org M933009684-4424 --service M933009684-4424
vca vdc use --vdc M933009684-4424

vca vapp create -a ubu -V ubuChefNode -c 'Public Catalog' -t 'Ubuntu Server 12.04 LTS (amd64 20150127)' -n M933009684-4424-default-routed -m POOL
vca vapp undeploy --vapp ubu
vca vapp customize --vapp ubu --vm ubuChefNode --file ./customize.sh

```

###### Provision the vCloud Air Gateway for ssh access to the VM 

```
// Get the IP returned for the VM, note: its on the VDC internal network
$ export IP=vca vm -a ubu | grep ubu | cut -d '|' -f5


// Configure a DNAT rule for ssh and http
vca nat add --type DNAT  --original-ip 23.92.225.229 --original-port 22 --translated-ip $IP --translated-port 22 --protocol any
vca nat add --type DNAT  --original-ip 23.92.225.229 --original-port 80 --translated-ip $IP --translated-port 80 --protocol any

// test ssh
ssh -v -i ./ubuntu.pem ubuntu@23.92.225.229 -p 22

```

###### Bootstrap the Server and provision using Chef 

```
// Bootstrap the node
$ knife solo prepare ubuntu@23.92.225.229 -p 22 -V --identity-file ../ubuntu_rsa 

// Configure using cookbooks
$ knife solo cook ubuntu@23.92.225.229 -p 22 -V --identity-file ../ubuntu_rsa 
```






###  Continuous Integration for a team of developers.


![WebSnapshot](https://github.com/rdbwebster/vcadevops/blob/master/images/devop2.png)

For larger development teams, configuration management and builds are centralized in Team Servers.
Configuration management will be managed by a centralized Chef Server running on vCloud air.
Applications builds and deployment are handled by a centralized Jenkins server on vCloud Air.


### Live Demo Environment

[Chef Server](https://devops.vcloudair.io/login)      vcadevops / welcome1




[Jenkins Server](http://devops.vcloudair.io:8100)     admin /  devops123


Ubuntu Server (vAPP)   

    Internal: 192.18.109.3 and 192.168.109.4
    External: 23.92.225.171

    SSH Access:    ssh root@d23.92.225.171
    use password: devops123


GitHub Account for Chef Cookbooks

    GitHub:  vcadevops
    Passwd:  vca4devops

Gmail Account needed for Github

    Email:   vcadevops@gmail.com
    Passwd:  vca4devops




### Install Desktop Workstation

Insructions to setup a developer workstation that can create and provision VMs on vCloud Air

[Instructions](https://github.com/rdbwebster/vcadevops/blob/master/Install.md)







### VDC Public Addresses

vCloud air Virtual Data Centers are configured by adminstrators with a finite number of public IP addresses.
A public IP address is not automatically assigned to each VM when it is created.Customers can configure the number of additional public IP’s, but it is common that there are more virtual machines than there are available Public Addresses.

In a devops environment, new instances may be created on demand and a mapping needs to be setup to enable access to the instances without their own publc IP.

There are several ways to acheive the mapping depending on whether administrative level access is available to the VDC gateway.

Gateway Administration Possible
If the gateway NAT configuration can be modified it is possible to configure new NAT rules on demand to route traffic from the public IP to a newly created VM on the internal network.
The vCloud Air CLI can create new NAT rules to map traffice based on the port id of the request.  For example a single public address on the gateway may be configured to listen on port 80, 81 and 82 and route requests to three different virtual machines each listening on port 80.  A similar mapping can be configured for ssh, so a single ip will listen on ports 22, 33 and 44, routing each to a unique VM listening on port 22.

This can be configured once by a Gateway administrator, or defined on demand using the vca-cli

On Demand Sample NAT rules

```
// Configure a DNAT rule for ssh and http, value of $IP is the address of the new VM on the internal network, example 192.168.109.5
vca nat add --type DNAT  --original-ip 23.92.225.229 --original-port 22 --translated-ip $IP --translated-port 22 --protocol any
vca nat add --type DNAT  --original-ip 23.92.225.229 --original-port 80 --translated-ip $IP --translated-port 80 --protocol any
```

### Static definition of Gateway NAT Rules

Configure the Gatway to serve dhcp ips from a define pool of addresses
```
vca dhcp add --network M933009684-4424-default-routed  --pool 192.168.109.101-192.168.109.105
```

When VMs are created, they are configured to have their internal IP addresses selected from pool of DHCP addresses.
For example 192.168.109.100 - 192.168.109.120

```
vca vapp create -a ubu -V ubuChefNode -c 'Public Catalog' -t 'Ubuntu Server 12.04 LTS (amd64 20150127)' -n M933009684-4424-default-routed -m DHCP 
```


Then in the gateway a define a set of port mapping rules for each ip for http and https to manage routing to the new VMs.

```
vca nat add --type DNAT  --original-ip 23.92.225.229 --original-port 81 --translated-ip  192.168.109.101 --translated-port 80 --protocol any
vca nat add --type DNAT  --original-ip 23.92.225.229 --original-port 444 --translated-ip 192.168.109.101 --translated-port 443 --protocol any
```

### Gateway administration not possible

If modification of the Gateway NAT rules are not possible or desirable,
an alternative approach is define a single vm on the private network
to act as an SSH Gateway and HHP(S) Gateway 

##### HTTP(S)

Setup Squid on a VM behind a Gateway public IP

##### SSH

Use one VM with a public ip mapping as an SSH Gateway


- Use the GW Load balancer or alternatively deploy a small unbuntu image behind the public ip
- have the gateway map all tcp ports from the public ip to the ubuntu server
- Have iptables route traffic to other vm's on the internal network depending or port or url.

// On the gateway server install the ubuntu public key in ~ubuntu/.ssh/authorized_keys 

###### On the Developer workstation modify the ~/.ssh/config

```
vi ~/.ssh/config

ServerAliveInterval 100

Host jenkins
  Hostname 23.92.225.171

Host 192.168.109.*
  User ubuntu
  IdentityFile /Users/bwebster/python/pippre/ubuntu_rsa
  ProxyCommand ssh -q jenkins -l ubuntu  -i /Users/bwebster/python/pippre/ubuntu_rsa  nc -q0 %h %p

``
Issue ssh command to access servers on the private network

For example, the following command will connect through the vm behind 23.92.225.171
```
   ssh 192.168.109.4

```


Simplifying setup for the developer workstation

Define Aliases for SSH

Developers can setup aliases in the ~/.ssh/.client file of their home directory to simplify port mappings.
For example

alpha   23.92.225.229 22
bravo   23.92.225.229 33
charlie 23.92.225.229 44

