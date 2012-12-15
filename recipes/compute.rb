#
# Cookbook Name:: vms
# Recipe:: compute
#
# Copyright 2012, Gridcentric Inc.
#

include_recipe "apt"

::Chef::Resource::AptRepository.send(:include, Gridcentric::Vms::Helpers)

if not platform?("ubuntu")
  raise "Unsupported platform: #{node["platform"]}"
end

repo_data = data_bag_item("gridcentric", "repos")

[ "vms", node["vms"]["os-version"] ].each do |repo|
  apt_repository "gridcentric-#{repo}" do
    uri construct_repo_uri(repo, repo_data)
    components ["gridcentric", "multiverse"]
    key construct_key_uri(repo_data)
    only_if { platform?("ubuntu") }
  end
end

execute "apt-get update" do
  command "apt-get update"
  action :run
end

package "linux-headers-#{node["kernel"]["release"]}" do
  action :install
end

package "nova-compute-gridcentric" do
  action :install
  options "-o APT::Install-Recommends=0"
end

template "/etc/sysconfig/vms" do
  source "vms.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(node["vms"]["sysconfig"])
end

execute "rm -rf /tmp/vms" do
  command "rm -rf /tmp/vms"
  action :run
end

service "nova-gc" do
  if node[:platform] == "ubuntu" and node[:platform_version].to_f >= 9.10
    provider Chef::Provider::Service::Upstart
  else
    # FIXME: We should add a proper init script in /etc/init.d for nova-gc.
    raise "Don't know how to restart nova-gc on platform #{node[:platform]}."
  end
  action :restart
end
