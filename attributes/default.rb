# /etc/sysconfig/vms config file parameters. Set to nil to comment out
# the appropriate line in the config file, provided the parameter
# isn't mandatory.

default["vms"]["sysconfig"]["vms_shelf_path"] = "/dev/shm"
default["vms"]["sysconfig"]["vms_shared_path"] = "/var/gridcentric"
default["vms"]["sysconfig"]["vms_disk_url"] = nil
default["vms"]["sysconfig"]["vms_memory_url"] = nil
default["vms"]["sysconfig"]["vms_logs"] = "/var/log/vms"
default["vms"]["sysconfig"]["vms_single_log"] = "false"
default["vms"]["sysconfig"]["vms_cache"] = "/tmp/vms"
default["vms"]["sysconfig"]["vms_store"] = nil
default["vms"]["sysconfig"]["vmsd_opts"] = ""
default["vms"]["sysconfig"]["vms_debug"] = "0"
default["vms"]["sysconfig"]["vms_guest_params"] = nil
default["vms"]["sysconfig"]["vms_ceph_conf"] = nil
default["vms"]["sysconfig"]["vms_qemu_cpu_model"] = nil
