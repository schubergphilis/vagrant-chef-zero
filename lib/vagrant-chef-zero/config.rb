require "vagrant"

module VagrantPlugins
  module ChefZero
    class Config < Vagrant.plugin("2", :config)

      # Path to role fixtures
      #
      # @return [String]
      attr_accessor :roles

      # Path to environment fixtures
      #
      # @return [String]
      attr_accessor :environments

      # Path to node fixtures
      #
      # @return [String]
      attr_accessor :nodes

      # Path to cookbooks
      #
      # @return [String]
      attr_accessor :cookbooks

      # Path to data bag fixtures
      #
      # @return [String]
      attr_accessor :data_bags

      # Is the plugin enabled?
      #
      # @return [TrueClass, FalseClass]
      attr_accessor :enabled

      # Path to a chef repo
      #
      # @return [String]
      attr_reader :chef_repo_path

      def chef_repo_path=(path)
        @chef_repo_path = path
        @roles = path_exists?("#{path}/roles") ? "#{path}/roles" : nil
        @environments = path_exists?("#{path}/environments") ? "#{path}/environments" : nil
        @nodes = path_exists?("#{path}/nodes") ? "#{path}/nodes" : nil
        @cookbooks = path_exists?("#{path}/cookbooks") ? "#{path}/cookbooks" : nil
        @data_bags = path_exists?("#{path}/data_bags") ? "#{path}/data_bags" : nil
      end


      def initialize
        @chef_repo_path = UNSET_VALUE
        @roles        = UNSET_VALUE
        @environments = UNSET_VALUE
        @nodes        = UNSET_VALUE
        @cookbooks    = UNSET_VALUE
        @data_bags    = UNSET_VALUE
        @enabled      = UNSET_VALUE
      end

      def validate(machine)
        { "Chef Zero" => [] }
      end

      def path_exists?(path)
        File.directory? path
      end

      def finalize!
        @enabled = true if @enabled == UNSET_VALUE
        @roles = nil if @roles == UNSET_VALUE
        @environments = nil if @environments == UNSET_VALUE
        @nodes = nil if @nodes == UNSET_VALUE
        @cookbooks = nil if @cookbooks == UNSET_VALUE
        @data_bags = nil if @data_bags == UNSET_VALUE
        @chef_repo_path = nil if @chef_repo_path == UNSET_VALUE
        {}
      end

    end
  end
end
