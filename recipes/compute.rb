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

[ "vms", node["vms"]["os-version"] ].each do |repo|
  apt_repository "gridcentric-#{repo}" do
    uri construct_repo_uri(repo, node)
    components ["gridcentric", "multiverse"]
    key construct_key_uri(node)
    only_if { platform?("ubuntu") }
  end
end

execute "apt-get update" do
  command "apt-get update"
  action :run
end

# Explicitly upgrade vms low-level components
[ "vms-libvirt", "vms-mcdist",
    "linux-headers-#{node["kernel"]["release"]}" ].each do |pkg|
  package pkg do
    action :upgrade
    options "-o Dpkg::Options::='--force-confnew'"
  end
end

if not node["vms"]["sysconfig"]["vms_ceph_conf"].nil?
  package "vms-rados" do
    action :upgrade
  end
end

if ["folsom", "essex", "diablo"].include?(node["vms"]["os-version"])
  package "nova-compute-gridcentric" do
    action :upgrade
    options "-o APT::Install-Recommends=0 -o Dpkg::Options::='--force-confnew'"
  end
else
  package "cobalt-compute" do
    action :upgrade
    options "-o APT::Install-Recommends=0 -o Dpkg::Options::='--force-confnew'"
  end
end

template "/etc/sysconfig/vms" do
  source "vms.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(node["vms"]["sysconfig"])
end

