#
# Cookbook Name:: vms
# Recipe:: api
#
# Copyright 2012, Gridcentric Inc.
#

include_recipe "apt"
include_recipe "vms"

if not platform?("ubuntu")
  raise "Unsupported platform: #{node["platform"]}"
end

apt_repository "gridcentric-cobalt" do
  uri node["gridcentric"]["repo"]["cobalt"]["uri"]
  components node["gridcentric"]["repo"]["components"]
  key node["gridcentric"]["repo"]["key-uri"]
  notifies :run, resources(:execute => "apt-get update"), :immediately
  only_if { platform?("ubuntu") }
end

if ["folsom", "essex", "diablo"].include?(node["gridcentric"]["os-version"])
  package "nova-api-gridcentric" do
    action :upgrade
    options "-o APT::Install-Recommends=0"
  end
else
  package "cobalt-api" do
    action :upgrade
    options "-o APT::Install-Recommends=0"
  end
end

