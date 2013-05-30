#
# Cookbook Name:: vms
# Library:: helpers
#
# Copyright 2013, Gridcentric Inc.
#
# Some common utility functions.
#

module Gridcentric
  module Repositories
      def self.translate_distro_to_repo_type(distro)
        case distro
        when "centos"
          return "centos"
        when "fedora"
          return "rpm"
        when "ubuntu"
          return "ubuntu"
        when "debian"
          return "deb"
        else
          raise "Unknown distro '#{distro}'"
        end
      end
  end
end
