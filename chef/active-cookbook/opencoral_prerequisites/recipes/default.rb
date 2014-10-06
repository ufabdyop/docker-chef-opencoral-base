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
include_recipe 'ant::install_source'
include_recipe 'apt'
include_recipe 'apache2'
include_recipe 'git'
include_recipe 'runit'
<<<<<<< HEAD
include_recipe 'maven'
=======
>>>>>>> a2fd5a0ee0caeb0cf74ac0b2188964d44e4f3f90

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

