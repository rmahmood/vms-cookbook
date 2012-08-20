#
# Cookbook Name:: vms
# Recipe:: vms
#
# Copyright 2012, Gridcentric Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apt"

if not platform?("ubuntu")
  raise "Unsupported platform: #{node["platform"]}"
end

repo_data = data_bag_item("gridcentric", "repos")

%w{ vms essex }.each do |repo|
  apt_repository "gridcentric-#{repo}" do
    uri "http://downloads.gridcentriclabs.com/packages/#{repo_data["private_key"]}/#{repo}/ubuntu/"
    components ["gridcentric", "multiverse"]
    key "http://downloads.gridcentriclabs.com/packages/gridcentric.key"
    notifies :run, resources(:execute => "apt-get update"), :immediately
    only_if { platform?("ubuntu") }
  end
end

package "linux-headers-#{node["kernel"]["release"]}" do
  action :install
end

package "nova-compute-gridcentric" do
  action :install
  options "-o APT::Install-Recommends=0"
end

