Description
===========

Installs the Gridcentric VMS+Cobalt platform from Gridcentric's package
repository.

See http://docs.gridcentric.com/openstack for instructions on how to obtain
access keys and documentation for VMS.

Requirements
============

This cookbook has been tested with Chef 0.10.12.

Platforms
---------

The host recipes (api, client and compute) were tested against the following
platforms:

* Ubuntu-12.04 (Precise Pangolin)

The guest recipe was tested against the following platforms:

* Ubuntu-12.04 (Precise Pangolin)
* Centos 6

All recipes should work on any platform with apt or yum.

Cookbooks
---------

This cookbook is dependent on the following cookbooks:

* apt
* yum

External Dependencies
---------------------

Gridcentric VMS+Cobalt is installed on a stock Openstack installation newer
than the "Diablo" release. This cookbook supports stock Openstack Essex, Folsom
or Grizzly installations. This cookbook has been tested against the openstack
cookbooks maintained by Rackspace (https://github.com/rcbops/chef-cookbooks).

Attributes
==========

The `node["gridcentric"]["os-version"]` attribute specifics the Openstack
version of the node. Valid values for this attribute are "essex", "folsom" and
"grizzly". Recipes make use of this value to select the appropriate package
repository.

All the attributes under `node["vms"]["sysconfig"]` are used to fill
in the the corresponding vms parameters in the `/etc/sysconfig/vms`
config file. See the template `default/vms.erb` for in-line
explanations of what these parameters do. The defaults are sufficient
for getting a working vms installation in a typical openstack node.

Finally, the attributes under `node["gridcentric"]["repo"]` specify the package
repository location. A private key provided by Gridcentric is required to access
some of the packages.

Recipes
=======

compute
-------
- Installs the VMS compute packages and the Cobalt compute openstack extension.
- Should be installed on openstack compute nodes.

api
---
- Installs the Cobalt api packages for servicing VMS requests.
- Should be installed on openstack api nodes.

client
------
- Installs the Cobalt client side python bindings. Useful for
  issuing requests to a VMS-enabled openstack cluster.


agent
-----
- Installs the VMS guest packages.
- Should be installed on any instance which will be blessed using VMS.

nfs
---
- Installs packages to mount an nfs volume
- mounts a `node["vms"]["sysconfig"]["shared_volume"]` on the `node["vms"]["sysconfig"]["vms_shared_path"]` mountpoint

dashboard
---------
- Installs the horizon Cobalt plugin to expose VMS actions on the openstack dashboard
- Installs the above mentioned client
- Should be installed on the openstack dashboard node

A note on Ceph
==============

The `compute` recipe aims to simplify as much as possible the configuration of
the VMS software with a Ceph storage cluster, if such combination is desired.

Simply create or choose the RADOS and RBD pools needed to store memory and disk
artifacts of a blessed image, respectively. Then specify them through the
`node["vms"]["sysconfig"]["rados_pool"]` and
`node["vms"]["sysconfig"]["rbd_pool"]` attributes.

Your VMS install should now be using Ceph storage.

You can achieve finer-grained configuration through the `["rados_prefix"]`,
`["rbd_prefix"]`, `["vms_ceph_conf"]` and `["vms_ceph_login"]` attributes of the
`["vms"]["sysconfig"]` node. The defaults are usually fine.

