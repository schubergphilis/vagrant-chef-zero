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

      attr_accessor :host

      def initialize
        super

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

      def finalize!
        @enabled = true if @enabled = UNSET_VALUE
        @host = provisioner.config.chef_server_url
        @roles = nil if @roles = UNSET_VALUE
        @environments = nil if @environments = UNSET_VALUE
        @nodes = nil if @nodes = UNSET_VALUE
        @cookbooks = nil if @cookbooks = UNSET_VALUE
        @data_bags = nil if @data_bags = UNSET_VALUE
        {}
      end

    end
  end
end