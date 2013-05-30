#
# Cookbook Name:: vms
# Recipe:: client
#
# Copyright 2012, Gridcentric Inc.
#

include_recipe "apt"
include_recipe "vms"

if not platform?("ubuntu")
  raise "Unsupported platform: #{node["platform"]}"
end

if platform?(%w{ ubuntu debian })
  apt_repository "gridcentric-cobaltclient" do
    uri node["gridcentric"]["repo"]["cobaltclient"]["uri"]
    components node["gridcentric"]["repo"]["components"]
    key node["gridcentric"]["repo"]["key-uri"]
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
elsif platform?(%w{ centos fedora })
  yum_key "RPM-GPG-KEY-gridcentric" do
    url node["gridcentric"]["repo"]["key-uri"]
    action :add
  end
  yum_repository "gridcentric-cobaltclient" do
    name "gridcentric-cobaltclient"
    url node["gridcentric"]["repo"]["cobaltclient"]["uri"]
    key "RPM-GPG-KEY-gridcentric"
    action :add
  end
  include_recipe "yum"
else
  raise "Unsupported platform: #{node["platform"]}"
end

package "cobalt-novaclient" do
  action :upgrade
  options "-o APT::Install-Recommends=0"
end
