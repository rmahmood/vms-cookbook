# The Openstack version on the node. Value should be either "essex",
# "folsom" or "grizzly".
default["gridcentric"]["os-version"] = "folsom"

# Repository parameters. These control how the gridcentric repositories are
# accessed during the node setup. To gain access to the private repositories,
# use the appropriate keys provided to you by Gridcentric.
default["gridcentric"]["repo"]["base-uri"] = "http://downloads.gridcentriclabs.com/packages"

default["gridcentric"]["repo"]["agent"]["key"] = "agent"
default["gridcentric"]["repo"]["cobalt"]["key"] = "cobalt"
default["gridcentric"]["repo"]["cobaltclient"]["key"] = "cobaltclient"
default["gridcentric"]["repo"]["vms"]["key"] = nil

# These attributes are aliases provided for compatibility reasons. These aliases
# are deprecated and may be removed in a future version. If provided, these are
# considered be of higher precendence than the canonical attributes since they
# are guranteed to be set by the user whereas the canonical attributes may have
# a default value.
#
#     # Fallback for default["gridcentric"]["os-version"]
#     default["vms"]["os-version"] = "folsom"
#
#     # Fallback for default["gridcentric"]["repo"]["base-uri"]
#     default["vms"]["repo"]["url"] = "http://downloads.gridcentriclabs.com/packages"
#
#     # Fallback for default["gridcentric"]["repo"]["vms"]["key"]
#     default["vms"]["repo"]["private_key"] = nil

# These attributes can be used to override the base uri for a specific
# component. If these attributes are not defined or set to nil, recipes will use
# the global repo uri instead.
#
#     default["gridcentric"]["repo"]["agent"]["uri"] = nil
#     default["gridcentric"]["repo"]["cobaltclient"]["uri"] = nil
#     default["gridcentric"]["repo"]["vms"]["uri"] = nil

# /etc/sysconfig/vms config file parameters. Set to nil to comment out the
# appropriate line in the config file, provided the parameter isn't
# mandatory. See the template 'vms.erb' for an inline explanation of what these
# parameters do.

default["vms"]["sysconfig"]["vms_user"] = nil
default["vms"]["sysconfig"]["vms_group"] = nil
default["vms"]["sysconfig"]["vms_shelf_path"] = "/dev/shm"
default["vms"]["sysconfig"]["vms_shared_path"] = "/var/gridcentric"
default["vms"]["sysconfig"]["vms_disk_url"] = nil
default["vms"]["sysconfig"]["vms_memory_url"] = nil
default["vms"]["sysconfig"]["vms_logs"] = "/var/log/vms"
default["vms"]["sysconfig"]["vms_single_log"] = "false"
default["vms"]["sysconfig"]["vms_cache"] = "/dev/shm/vms"
default["vms"]["sysconfig"]["vms_store"] = nil
default["vms"]["sysconfig"]["vmsd_opts"] = ""
default["vms"]["sysconfig"]["vms_debug"] = "0"
default["vms"]["sysconfig"]["vms_guest_params"] = nil
default["vms"]["sysconfig"]["vms_ceph_conf"] = nil
default["vms"]["sysconfig"]["vms_ceph_login"] = nil
default["vms"]["sysconfig"]["vms_qemu_cpu_model"] = nil

default["vms"]["sysconfig"]["shared_device"] = nil
default["vms"]["sysconfig"]["shared_volume"] = nil

default["vms"]["sysconfig"]["rados_pool"] = nil
default["vms"]["sysconfig"]["rados_prefix"] = nil
default["vms"]["sysconfig"]["rbd_pool"] = nil
default["vms"]["sysconfig"]["rbd_prefix"] = nil
