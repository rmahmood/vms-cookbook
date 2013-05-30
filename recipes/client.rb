#
# Cookbook Name:: vms
# Recipe:: client
#
# Copyright 2012, Gridcentric Inc.
#

include_recipe "apt"
::Chef::Recipe.send(:include, Gridcentric)

if not platform?("ubuntu")
  raise "Unsupported platform: #{node["platform"]}"
end

if platform?(%w{ ubuntu debian })
  apt_repository "gridcentric-cobaltclient" do
    uri "#{node["vms"]["repo"]["url"].chomp("/")}/" +
        "#{node["vms"]["repo"]["client_key"]}/" +
        "#{node["vms"]["os-version"]}/" +
        "#{Vms::Helpers.translate_distro_to_repo(node["platform"])}"
    if platform?("ubuntu")
      components ["gridcentric", "multiverse"]
    else
      components ["gridcentric", "non-free"]
    end
    key Vms::Helpers.construct_key_uri(node)
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
elsif platform?(%w{ centos fedora })
  yum_key "RPM-GPG-KEY-gridcentric" do
    url Vms::Helpers.construct_key_uri(node)
    action :add
  end
  yum_repository "gridcentric-cobaltclient" do
    name "gridcentric-cobaltclient"
    url "#{node["vms"]["repo"]["url"].chomp("/")}/" +
        "#{node["vms"]["repo"]["client_key"]}/" +
        "#{node["vms"]["os-version"]}/" +
        "#{Vms::Helpers.translate_distro_to_repo(node["platform"])}"
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
