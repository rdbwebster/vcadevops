# vcadevops




## Devops with vCloud Air

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
vca nat add --type DNAT  --original-ip 23.92.225.229 --original-port 22 --translated-ip 192.168.109.2 --translated-port 22 --protocol any
vca nat add --type DNAT  --original-ip 23.92.225.229 --original-port 80 --translated-ip 192.168.109.2 --translated-port 80 --protocol any

// test ssh
ssh -v -i ./ubuntu.pem ubuntu@23.92.225.229 -p 33

```

###### Bootstrap the Server and provision using Chef 

```
// Bootstrap the node
$ knife solo prepare ubuntu@23.92.225.229 -p 33 -V --identity-file ../ubuntu_rsa 

// Configure using cookbooks
$ knife solo cook ubuntu@23.92.225.229 -p 33 -V --identity-file ../ubuntu_rsa 
```






###  Continuous Integration for a team of developers.


![WebSnapshot](https://github.com/rdbwebster/vcadevops/blob/master/images/devop2.png)

For larger development teams, configuration management and builds are centralized in Team Servers.
Configuration management will be managed by a centralized Chef Server running on vCloud air.
Applications builds and deployment are handled by a centralized Jenkins server on vCloud Air.


Live Demo Environment

[Chef Server](https://devops.vcloudair.io/login)      devops / devops123




[Jenkins Server](http://devops.vcloudair.io:8100)     admin /  devops123


Ubuntu Server (vAPP)   

Internal: 192.18.109.3 and 192.168.109.4

External: 23.92.225.171

ssh Access:    ssh root@d23.92.225.171
use password: devops123





### VDC Public Addresses

vCloud air Virtual Data Centers are configured with a finite number of public IP addresses.  A public IP address is not automatically assigned to each VM when it is created.  Customers can configure the number of additional public IP’s, but it is common that there are more virtual machines than there are available Public Addresses.

The shortfall of public addresses can be resolved by configuring the NAT server on the VDC Gateway to route traffic based on port.  For example a single public address may be configured to listen on port 80, 81 and 82 and route requests to three different virtual machines each listening on port 80.  A similar mapping can be configured for ssh, so a single ip will listen on ports 22, 33 and 44, routing each to a unique VM listening on port 22.

