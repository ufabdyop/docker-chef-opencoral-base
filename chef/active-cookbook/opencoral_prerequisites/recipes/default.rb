#
# Cookbook Name:: opencoral
# Recipe:: default
#
# Copyright 2014, University of Utah Nanofab
#
# All rights reserved - Do Not Redistribute
#

# load passwords
my_secret = Chef::EncryptedDataBagItem.load_secret("/chef/secret/encrypted_data_bag_secret")
passwords = Chef::EncryptedDataBagItem.load("passwords", "general", my_secret)

# get postgres password and install postgres
# node.override['postgresql']['password']['postgres'] = passwords['postgres']

include_recipe 'java'
include_recipe 'java::oracle'
include_recipe 'ant::install_source'
include_recipe 'apt'
include_recipe 'apache2'
include_recipe 'git'

# set root password
rootpass = passwords['root']
execute "Set root password" do
  command "echo 'root:#{rootpass}' | chpasswd"
end

link "/usr/bin/ant" do
  to "/usr/local/ant-1.8.2/bin/ant"
end

package "ca-certificates" 
package "cvs"
package "rsync"
package "sudo"
package "openssl"
package "openssh-server"
package "perl"
package "gcc"
package "software-properties-common"
package "x11-apps"
package "libxtst6"
package "libxi6"
package "libgconf-2-4"

