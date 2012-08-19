#
# Cookbook Name:: vms
# Recipe:: agent
#
# Copyright 2012, Gridcentric Inc.
#
# All rights reserved - Do Not Redistribute
#

repo_data = data_bag_item("gridcentric", "repos")

# Add the appropriate source list based on the platform.
if platform?("ubuntu")
  apt_repository "gridcentric-vms" do
    uri "http://downloads.gridcentriclabs.com/packages/#{repo_data["public_key"]}/vms/ubuntu/"
    components ["gridcentric", "multiverse"]
    key "http://downloads.gridcentriclabs.com/packages/gridcentric.key"
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
elsif platform?("debian")
  apt_repository "gridcentric-vms" do
    uri "http://downloads.gridcentriclabs.com/packages/#{repo_data["public_key"]}/vms/deb/"
    components ["gridcentric", "non-free"]
    key "http://downloads.gridcentriclabs.com/packages/gridcentric.key"
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
elsif platform?(%w{ centos fedora })
  yum_key "RPM-GPG-KEY-gridcentric" do
    url "http://downloads.gridcentriclabs.com/packages/gridcentric.key"
    action :add
  end
  yum_repository "gridcentric-vms" do
    name "gridcentric-vms"
    url "http://downloads.gridcentriclabs.com/packages/#{repo_data["public_key"]}/vms/#{node["platform"]}"
    key "RPM-GPG-KEY-gridcentric"
    action :add
  end
  include_recipe "yum"
else
  raise "Unsupported platform: #{node["platform"]}"
end

package "vms-agent" do
  action :install
end
