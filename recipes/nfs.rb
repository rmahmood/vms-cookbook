#
# Cookbook Name:: vms
# Recipe:: nfs
#

if  platform?("ubuntu")
  package "nfs-common" do
    action :upgrade
  end
end

if platform_family?("rhel")
  package "nfs-utils" do
    action :upgrade
  end
end

mount node["vms"]["sysconfig"]["vms_shared_path"] do
  device "#{node["vms"]["sysconfig"]["shared_device"]}:#{node["vms"]["sysconfig"]["shared_volume"]}"
  fstype "nfs"
  options "rw"
end
