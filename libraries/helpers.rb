#
# Cookbook Name:: vms
# Library:: utils
#
# Copyright 2012, Gridcentric Inc.
#
# Some common utility functions used in various recipies.
#

module Gridcentric
  module Vms
    module Helpers

      def self.construct_repo_uri(repo, node)
        if not node["vms"]["repo"]["private_key"].nil?
          return [node["vms"]["repo"]["url"].chomp("/"),
                  node["vms"]["repo"]["private_key"],
                  repo, "ubuntu"].join("/")
        else
          return [node["vms"]["repo"]["url"].chomp("/"),
                  repo, "ubuntu"].join("/")
        end
      end

      def self.construct_key_uri(node)
        return [node["vms"]["repo"]["url"].chomp("/"),
                "gridcentric.key"].join("/")
      end

      def self.translate_distro_to_repo(distro)
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
end
