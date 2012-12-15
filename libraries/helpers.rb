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

      def construct_repo_uri(repo, repo_data)
        if not repo_data["private_key"].nil?
          return [repo_data["base_url"].chomp("/"), repo_data["private_key"],
                  repo, "ubuntu"].join("/")
        else
          return [repo_data["base_url"].chomp("/"), repo, "ubuntu"].join("/")
        end
      end

      def construct_key_uri(repo_data)
        return [repo_data["base_url"].chomp("/"), "gridcentric.key"].join("/")
      end

    end
  end
end

