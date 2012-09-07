#
# Cookbook Name:: vms
# Recipe:: disable_apparmor
#
# Copyright 2012, Gridcentric Inc.
#

execute "disable apparmor" do
  command "find /etc/apparmor.d -name 'usr*libvirt*' | xargs -n1 -I{} mv {} /etc/apparmor.d/disable"
  action :run
end

service "apparmor" do
  action :restart
end

service "libvirt-bin" do
  action :restart
end
