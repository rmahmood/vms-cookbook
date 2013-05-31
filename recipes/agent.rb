#
# Cookbook Name:: vms
# Recipe:: agent
#
# Copyright 2012, Gridcentric Inc.
#

include_recipe "apt"
::Chef::Recipe.send(:include, Gridcentric)

# Add the appropriate source list based on the platform.
if platform?(%w{ ubuntu debian })
  apt_repository "gridcentric-agent" do
    uri "#{node["vms"]["repo"]["url"].chomp("/")}/" +
        "#{node["vms"]["repo"]["agent_key"]}/linux/" +
        "#{Vms::Helpers.translate_distro_to_repo(node["platform"])}"
    if platform?("ubuntu")
      components ["gridcentric", "multiverse"]
    else
      components ["gridcentric", "non-free"]
    end
    key Vms::Helpers.construct_repo_uri(node)
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
elsif platform?(%w{ centos fedora })
  yum_key "RPM-GPG-KEY-gridcentric" do
    url Vms::Helpers.construct_repo_uri(node)
    action :add
  end
  yum_repository "gridcentric-agent" do
    name "gridcentric-agent"
    url "#{node["vms"]["repo"]["url"].chomp("/")}/" +
        "#{node["vms"]["repo"]["agent_key"]}/linux/" +
        "#{Vms::Helpers.translate_distro_to_repo(node["platform"])}"
    key "RPM-GPG-KEY-gridcentric"
    action :add
  end
  include_recipe "yum"
else
  raise "Unsupported platform: #{node["platform"]}"
end

package "linux-headers-#{node["kernel"]["release"]}" do
  action :upgrade
end

package "vms-agent" do
  action :upgrade
end
