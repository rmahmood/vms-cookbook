#
# Cookbook Name:: vms
# Recipe:: agent
#
# Copyright 2012, Gridcentric Inc.
#

include_recipe "apt"
include_recipe "vms"

# Add the appropriate source list based on the platform.
if platform?(%w{ ubuntu debian })
  apt_repository "gridcentric-agent" do
    uri node["gridcentric"]["repo"]["agent"]["uri"]
    components node["gridcentric"]["repo"]["components"]
    key node["gridcentric"]["repo"]["key-uri"]
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
elsif platform?(%w{ centos fedora })
  yum_key "RPM-GPG-KEY-gridcentric" do
    url node["gridcentric"]["repo"]["key-uri"]
    action :add
  end
  yum_repository "gridcentric-agent" do
    name "gridcentric-agent"
    url node["gridcentric"]["repo"]["agent"]["uri"]
    key "RPM-GPG-KEY-gridcentric"
    action :add
  end
  include_recipe "yum"
else
  raise "Unsupported platform: #{node["platform"]}"
end

package "linux-headers-#{node["kernel"]["release"]}" do
  action :upgrade
end

package "vms-agent" do
  action :upgrade
end
