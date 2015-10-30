# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
  log_level                :info
  log_location             STDOUT
 # user = ENV['OPSCODE_USER'] || ENV['USER']
  user = "ubuntu"
  node_name                user
  client_key               "/home/ubuntu/vcadevops/chef-repo/.chef/chef-ubuntu.pem"
  validation_client_name   "chef-validator"
  validation_key           "/home/ubuntu/vcadevops/chef-repo/.chef/chef-validator.pem"
 # Use internal address to avoid vCloud Hairpin Nat Issue, use IP since internal chef server names not in /etc/hosts file of new server
  chef_server_url          "https://chef.vcair.us:443/organizations/chef"
  cookbook_path            ["/home/ubuntu/vcadevops/chef-repo/cookbooks"]
  cookbook_copyright "VMWare."
  cookbook_license "apachev2"
  cookbook_email "vcadevops@gmail.com"

knife[:host_key_verify] = true
cookbook_path [ '/home/ubuntu/vcadevops/chef-repo/cookbooks/']

#OnDemand
knife[:vcair_api_host] = 'us-california-1-3.vchs.vmware.com'
knife[:vcair_org] = 'ec7274ed-5dfc-43fa-9961-b3611e78aa99'
knife[:vcair_api_path] = '/api/compute/api'

#vchs
#knife[:vcair_api_host] = 'p3v10-vcd.vchs.vmware.com'
#knife[:vcair_org] = 'M933009684-4424'

# NOT hard coded
knife[:vcair_username] = "#{ENV['VCAIR_USER']}"
knife[:vcair_password] = "#{ENV['VCAIR_PASS']}"
