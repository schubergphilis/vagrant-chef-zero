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
        @chef_repo_path = File.expand_path(path)
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
        @roles = expand_paths(@roles) if @roles
        @environments = nil if @environments == UNSET_VALUE
        @environments = expand_paths(@environments) if @environments
        @nodes = nil if @nodes == UNSET_VALUE
        @nodes = expand_paths(@nodes) if @nodes
        @cookbooks = nil if @cookbooks == UNSET_VALUE
        @cookbooks = expand_paths(@cookbooks) if @cookbooks
        @data_bags = nil if @data_bags == UNSET_VALUE
        @data_bags = expand_paths(@data_bags) if @data_bags
        @chef_repo_path = nil if @chef_repo_path == UNSET_VALUE
        {}
      end

      private

      def expand_paths(attribute)
        if attribute.kind_of?(Array)
          attribute.map { |path| File.expand_path(path) }
        else
          File.expand_path(attribute)
        end
      end
    end
  end
end
