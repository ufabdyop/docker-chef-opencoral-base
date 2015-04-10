#
# Cookbook Name:: opencoral
# Recipe:: database
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

execute "Update apt" do
    command "apt-get update"
end

execute "remove private key directory to fix issue #156" do
  command "rm -rf /etc/ssl/private"
end

user "postgres" do
  action :create
  uid 1001
end

group "ssl-cert" do
  members ["postgres"]
end

directory "/etc/ssl/private" do
  owner "root"
  group "ssl-cert"
  mode 00710
  action :create
end

cookbook_file "/etc/ssl/private/postgresql.key" do
  source "postgresql.key"
  mode 0640
  owner "root"
  group "ssl-cert"
end

cookbook_file "/etc/ssl/certs/postgresql.pem" do
  source "postgresql.pem"
  mode 0644
  owner "root"
  group "root"
end

#load passwords
# my_secret = Chef::EncryptedDataBagItem.load_secret("/chef/secret/encrypted_data_bag_secret")
# passwords = Chef::EncryptedDataBagItem.load("passwords", "general", my_secret)
# node.override['postgresql']['password']['postgres'] = passwords['postgres']

#get postgres password and install postgres
include_recipe 'postgresql::server'

cookbook_file "/etc/postgresql/9.3/main/pg_hba.conf" do
  source "pg_hba.conf"
  mode 0644
  owner "root"
  group "root"
end

cookbook_file "/tmp/Pg83-implicit-casts.sql_id22" do
  source "Pg83-implicit-casts.sql_id22"
end

execute "run sql implicit casts file" do
  command "su postgres -c 'psql -f /tmp/Pg83-implicit-casts.sql_id22'"
end

execute "clean up db files" do
  command "rm /tmp/Pg83-implicit-casts.sql_id22"
end
