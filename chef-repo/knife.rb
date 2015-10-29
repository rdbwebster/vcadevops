user = "ubuntu"
node_name                user
client_key              "/home/ubuntu/vcadevops/chef-repo/.chef/chef-ubuntu.pem"
validation_client_name  "chef-validator"
validation_key           "/home/ubuntu/vcadevops/chef-repo/.chef/chef-validator.pem"
chef_server_url          "https://chef.vcair.us/organizations/chef"

#OnDemand
knife[:vcair_api_host] = 'us-california-1-3.vchs.vmware.com'
knife[:vcair_org] = 'ec7274ed-5dfc-43fa-9961-b3611e78aa99'
knife[:vcair_api_path] = '/api/compute/api'

#vchs
#knife[:vcair_api_host] = 'p3v10-vcd.vchs.vmware.com'
#knife[:vcair_org] = 'M933009684-4424'

#Both
knife[:vcair_username] = ENV['VCA_USER']
knife[:vcair_password] = ENV['VCA_PASS']
~                                                                        
