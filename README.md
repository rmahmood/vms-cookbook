Description
===========

Installs the Gridcentric VMS platform from Gridcentric's package repository.

See http://docs.gridcentric.com/openstack for instructions on how to obtain
access keys and documentation for VMS.

Requirements
============

This cookbook has been tested with Chef 0.10.12.

Platforms
---------

The hypervisor/host recipes (api, client and compute) were tested against the
following platforms:

* Ubuntu-12.04 (Precise Pangolin)

The guset recipe was tested against the following platforms:

* Ubuntu-12.04 (Precise Pangolin)
* Centos 6

The all recipes should work on any platform with apt or yum.

Cookbooks
---------

This cookbook is dependent on the following cookbooks:

* apt
* yum

External Dependencies
---------------------

Gridcentric VMS requires a stock Openstack 'Essex' or newer installation. This
cookbook has been tested against the openstack cookbooks maintained by Rackspace
(https://github.com/rcbops/chef-cookbooks).

Attributes
==========

The `node["gridcentric"]["os-version"]` attribute specifics the Openstack
version of the node. Valid values for this attribute are "essex", "folsom" and
"grizzly". Recipes make use of this value to select the appropriate package
repository.

All the attributes under `node["vms"]["sysconfig"]` are used to fill in the the
corresponding vms parameters in the `/etc/sysconfig/vms` config file. See the
template `default/vms.erb` for in-line explanations of what these parameters
do. The defaults are sufficient for getting a working vms installation in a
typical openstack node.

Finally, the attributes under `node["gridcentric"]["repo"]` specify the package
repository location. A private key provided by Gridcentric is required to access
some of the packages.

Recipes
=======

compute
-------
- Installs the VMS compute packages and relevant openstack extensions.
- Should be installed on openstack compute nodes.

api
---
- Installs the api packages for servicing VMS requests.
- Should be installed on openstack api nodes.

client
------
- Installs the python bindings for the openstack VMS extension. Useful for
  issuing VMS requests to a VMS-enabled openstack cluster.

dashboard
---------
- Installs the horizon-gridcentric package for integrating with horizon
- Installs the above mentioned client

nfs
---
- Installs packages to mount an nfs volume
- mounts a `node["vms"]["sysconfig"]["shared_volume"]` on the
  `node["vms"]["sysconfig"]["vms_shared_path"]` mountpoint

agent
-----
- Installs the VMS gust packages.
- Should be installed on any instance which will be blessed using VMS.
