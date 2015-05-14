## Install Demo

The demo is centered around an ubuntu server that contains various devops tools.
The server is available as a vApp in a private VDC 4407 vCloud Air catalog.


### Configure Gateway DHCP
Configure the Gateway to serve dhcp ips from a define pool of addresses
This can be done through the vCloud air console or using vca-cli
```
vca dhcp add --network M933009684-4424-default-routed  --pool 192.168.109.101-192.168.109.120
```

When VMs are created, they are configured to have their internal IP addresses selected from pool of DHCP addresses.
For example 192.168.109.100 - 192.168.109.120

```
vca vapp create -a ubu -V ubuChefNode -c 'Public Catalog' -t 'Ubuntu Server 12.04 LTS (amd64 20150127)' -n M933009684-4424-default-routed -m DHCP 
```

Also enable DNS forwarding in the Gateway, this is needed by the Photon scenario since it is not configured with name servers since the current version does not support customization.
Add 8.8.8.8 as a secondary dns server in the configuration after the gateway 192.168.109.1

