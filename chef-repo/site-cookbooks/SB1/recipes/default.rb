#
# Cookbook Name:: SB1
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "/etc/motd" do
   source "motd"
   mode "0644"
end

execute "apt-get update" do
  user "root"
end


execute "sudo aptitude  --assume-yes install openjdk-7-jdk" do
  user "root" 
end

# include_recipe 'java::default'

