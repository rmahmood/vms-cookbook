#
# Cookbook Name:: vms
# Recipe:: client
#
# Copyright 2012, Gridcentric Inc.
#

include_recipe "apt"

::Chef::Resource::AptRepository.send(:include, Gridcentric::Vms::Helpers)

if not platform?("ubuntu")
  raise "Unsupported platform: #{node["platform"]}"
end

repo_data = data_bag_item("gridcentric", "repos")

apt_repository "gridcentric-#{node["vms"]["os-version"]}" do
  uri construct_repo_uri(node["vms"]["os-version"], repo_data)
  components ["gridcentric", "multiverse"]
  key construct_key_uri(repo_data)
  notifies :run, resources(:execute => "apt-get update"), :immediately
  only_if { platform?("ubuntu") }
end

package "python-novaclient" do
  action :upgrade
end

package "novaclient-gridcentric" do
  action :install
  options "-o APT::Install-Recommends=0"
end
