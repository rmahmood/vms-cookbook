#
# Cookbook Name:: vms
# Recipe:: agent
#
# Copyright 2012, Gridcentric Inc.
#

include_recipe "apt"

repo_data = data_bag_item("gridcentric", "repos")
distro_repo_map = Hash[ "centos" =>  "centos",
                        "fedora" => "rpm",
                        "ubuntu" => "ubuntu",
                        "debian" => "deb"
                      ]

# Add the appropriate source list based on the platform.
if platform?(%w{ ubuntu debian })
  apt_repository "gridcentric-public" do
    uri "#{repo_data["base_url"].chomp("/")}/" +
      "#{repo_data["public_key"]}/agent/#{distro_repo_map[node["platform"]]}/"
    if platform?("ubuntu")
      components ["gridcentric", "multiverse"]
    else
      components ["gridcentric", "non-free"]
    end
    key "#{repo_data["base_url"].chomp("/")}/gridcentric.key"
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
elsif platform?(%w{ centos fedora })
  yum_key "RPM-GPG-KEY-gridcentric" do
    url "#{repo_data["base_url"].chomp("/")}/gridcentric.key"
    action :add
  end
  yum_repository "gridcentric-vms" do
    name "gridcentric-vms"
    url "#{repo_data["base_url"]}/#{repo_data["public_key"]}" +
      "/agent/#{distro_repo_map[node["platform"]]}"
    key "RPM-GPG-KEY-gridcentric"
    action :add
  end
  include_recipe "yum"
else
  raise "Unsupported platform: #{node["platform"]}"
end

package "linux-headers-#{node["kernel"]["release"]}" do
  action :install
end

package "vms-agent" do
  action :install
end
