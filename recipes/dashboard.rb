#
# Cookbook Name:: vms
# Recipe:: dashboard
#
# Copyright 2012, Gridcentric Inc.
#

include_recipe "vms"
include_recipe "vms::client"

if platform?("ubuntu")
  include_recipe "apt"
  apt_repository "gridcentric-cobalt" do
    uri node["gridcentric"]["repo"]["cobalt"]["uri"]
    components node["gridcentric"]["repo"]["components"]
    key node["gridcentric"]["repo"]["key-uri"]
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
elsif platform_family?("rhel")
  yum_repository "gridcentric-cobalt" do
    url node["gridcentric"]["repo"]["cobalt"]["uri"]
    key "RPM-GPG-KEY-gridcentric"
  end
else
  raise "Unsupported platform: #{node["platform"]}"
end

if ["folsom", "essex", "diablo"].include?(node["gridcentric"]["os-version"])
  package "horizon-gridcentric" do
    action :upgrade
    if platform?("ubuntu")
      options "-o APT::Install-Recommends=0"
    end
  end
else
  package "cobalt-horizon" do
    action :upgrade
    if platform?("ubuntu")
      options "-o APT::Install-Recommends=0"
    end
  end
end
