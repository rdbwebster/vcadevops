# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
  log_level                :info
  log_location             STDOUT
 # user = ENV['OPSCODE_USER'] || ENV['USER']
  user = "ubuntu"
  node_name                user
 # client_key               "#{ENV['HOME']}/.chef/#{user}.pem"
  client_key               "/home/ubuntu/vcadevops/chef-repo/.chef/ubuntu.pem"
 # client_key               "#{current_dir}/ubuntu.pem"
 # validation_client_name   "#{ENV['ORGNAME']}-validator"
  validation_client_name   "chef-validator"
 # validation_key           "#{ENV['HOME']}/.chef/#{ENV['ORGNAME']}-validator.pem"
  validation_key           "/home/ubuntu/vcadevops/chef-repo/.chef/chef-validator.pem"
 # validation_key           "#{current_dir}/chef-validator.pem"
 # chef_server_url          "https://api.opscode.com/organizations/#{ENV['ORGNAME']}"
  chef_server_url          "https://devops.vcloudair.io/organizations/chef"
  syntax_check_cache_path  "#{ENV['HOME']}/.chef/syntax_check_cache"
 # cookbook_path            ["#{current_dir}/../cookbooks"]
  cookbook_path            ["/home/ubuntu/vcadevops/chef-repo/cookbooks"]
  cookbook_copyright "VMWare."
  cookbook_license "apachev2"
  cookbook_email "vcadevops@gmail.com"

# NOT hard coded
knife[:vcair_api_host] = "#{ENV['VCAIR_API_URL']}"
knife[:vcair_username] = "#{ENV['VCAIR_USERNAME']}"
knife[:vcair_password] = "#{ENV['VCAIR_PASSWORD']}"
knife[:vcair_org] = "#{ENV['VCAIR_ORG']}"
