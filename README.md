# vcadevops




Devops with vCloud Air

####  An individual Developer

![WebSnapshot](https://github.com/rdbwebster/vcadevops/blob/master/images/devop1.png)


In this first case we consider an individual developer who has existing cookbooks and application assets and would like to deploy the application to a configured Virtual Machine on vCloud Air.  The OS template may be a stock template provided by vmware or a custom gold template provided by the enterprise.

The developer is working from a workstation and is not part of a team leveraging a Chef Server for configuration management. In this case the developer will utilize the vcloud air cli to create the vm and configure the network,  and Chef-solo to do the provisioning and application deployment.




####  Continuous Integration for a team of developers.


![WebSnapshot](https://github.com/rdbwebster/vcadevops/blob/master/images/devop2.png)

For larger development teams, configuration management and builds are centralized in a Team Server.  Configuration management will be handled by a Chef Server with applications builds and deployment handled by a Continuous Integration Server such a Jenkins.



### VDC Public Addresses

vCloud air Virtual Data Centers are configured with a finite number of public IP addresses.  A public IP address is not automatically assigned to each VM when it is created.  Customers can configure the number of additional public IP’s, but it is common that there are more virtual machines than there are available Public Addresses.

The shortfall of public addresses can be resolved by configuring the NAT server on the VDC Gateway to route traffic based on port.  For example a single public address may be configured to listen on port 80, 81 and 82 and route requests to three different virtual machines each listening on port 80.  A similar mapping can be configured for ssh, so a single ip will listen on ports 22, 33 and 44, routing each to a unique VM listening on port 22.

