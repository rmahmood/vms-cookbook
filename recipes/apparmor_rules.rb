#
# Cookbook Name:: vms
# Recipe:: apparmor_rules
#
# Copyright 2012, Gridcentric Inc.
#

include_recipe "apt"
include_recipe "vms"

if not platform?("ubuntu")
  raise "Unsupported platform: #{node["platform"]}"
end

apt_repository "gridcentric-vms" do
  uri node["gridcentric"]["repo"]["vms"]["uri"]
  components node["gridcentric"]["repo"]["components"]
  key node["gridcentric"]["repo"]["key-uri"]
  notifies :run, resources(:execute => "apt-get update"), :immediately
  only_if { platform?("ubuntu") }
end

package "vms-apparmor" do
  action :upgrade
  options "-o APT::Install-Recommends=0"
end
