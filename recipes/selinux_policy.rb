#
# Cookbook Name:: vms
# Recipe:: selinux_policy
#
# Copyright 2013, Gridcentric Inc.
#

include_recipe "yum"
include_recipe "vms"

if not platform_family?("rhel")
  raise "Unsupported platform: #{node["platform"]}"
end

yum_repository "gridcentric-vms" do
  url node["gridcentric"]["repo"]["vms"]["uri"]
  key "RPM-GPG-KEY-gridcentric"
end

package "vms-selinux" do
  action :upgrade
end
