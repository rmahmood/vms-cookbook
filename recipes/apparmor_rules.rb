#
# Cookbook Name:: vms
# Recipe:: apparmor_rules
#
# Copyright 2012, Gridcentric Inc.
#

include_recipe "apt"

::Chef::Resource::AptRepository.send(:include, Gridcentric::Vms::Helpers)

if not platform?("ubuntu")
  raise "Unsupported platform: #{node["platform"]}"
end

repo_data = data_bag_item("gridcentric", "repos")

apt_repository "gridcentric-vms" do
  uri construct_repo_uri("vms", repo_data)
  components ["gridcentric", "multiverse"]
  key construct_key_uri(repo_data)
  notifies :run, resources(:execute => "apt-get update"), :immediately
  only_if { platform?("ubuntu") }
end

package "vms-apparmor" do
  action :install
  options "-o APT::Install-Recommends=0"
end
