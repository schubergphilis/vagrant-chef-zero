require "vagrant"

module VagrantPlugins
  module ChefZero
    class Config < Vagrant.plugin("2", :config)

      attr_accessor :roles
      attr_accessor :environments
      attr_accessor :nodes
      attr_accessor :cookbooks
      attr_accessor :data_bags
      attr_accessor :enabled

      def initialize
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
        @enabled = true if @enabled == UNSET_VALUE
        @roles = nil if @roles == UNSET_VALUE
        @environments = nil if @environments == UNSET_VALUE
        @nodes = nil if @nodes == UNSET_VALUE
        @cookbooks = nil if @cookbooks == UNSET_VALUE
        @data_bags = nil if @data_bags == UNSET_VALUE
        {}
      end

    end
  end
end