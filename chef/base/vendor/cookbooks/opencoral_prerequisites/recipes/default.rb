#
# Cookbook Name:: opencoral
# Recipe:: default
#
# Copyright 2014, University of Utah Nanofab
#
# All rights reserved - Do Not Redistribute
#

# get postgres password and install postgres
# node.override['postgresql']['password']['postgres'] = passwords['postgres']

include_recipe 'java'
include_recipe 'java::oracle'

include_recipe 'opencoral_prerequisites::ant'
include_recipe 'apt'
include_recipe 'apache2'
include_recipe 'git'
include_recipe 'runit'
include_recipe 'maven'

link "/usr/bin/ant" do
  to "/usr/local/ant/bin/ant"
end

link "/usr/local/bin/mvn" do
  to "/usr/local/maven/bin/mvn"
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

user "coral" do
  action :create
  uid 1000
  home "/home/coral"
  shell "/bin/bash"
end
