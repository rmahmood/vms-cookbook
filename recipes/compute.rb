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

unless node["vms"]["sysconfig"]["rados_pool"].nil?
  if node["vms"]["sysconfig"]["vms_memory_url"].nil?
    node["vms"]["sysconfig"]["vms_memory_url"] = "rados://#{node["vms"]["sysconfig"]["rados_pool"]}"
    unless node["vms"]["sysconfig"]["rados_prefix"].nil?
      node["vms"]["sysconfig"]["vms_memory_url"] += "/#{node["vms"]["sysconfig"]["rados_prefix"]}"
    end
  end

  package "vms-rados" do
    action :upgrade
  end
end

unless node["vms"]["sysconfig"]["rbd_pool"].nil?
  if node["vms"]["sysconfig"]["vms_disk_url"].nil?
    node["vms"]["sysconfig"]["vms_disk_url"] = "rbd:#{node["vms"]["sysconfig"]["rbd_pool"]}"
    unless node["vms"]["sysconfig"]["rbd_prefix"].nil?
      node["vms"]["sysconfig"]["vms_disk_url"] += "/#{node["vms"]["sysconfig"]["rbd_prefix"]}"
    end
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

