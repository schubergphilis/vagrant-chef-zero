require 'vagrant/action/builder'
require 'vagrant-chef-zero/env_helpers'
require 'vagrant-chef-zero/server_helpers'

module VagrantPlugins
  module ChefZero
    module Action

      include Vagrant::Action::Builtin

      autoload :Start, 'vagrant-chef-zero/action/start'
      autoload :Upload, 'vagrant-chef-zero/action/upload'
      autoload :Stop, 'vagrant-chef-zero/action/stop'

      def self.chef_zero_provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use VagrantPlugins::ChefZero::Action::Start
          b.use VagrantPlugins::ChefZero::Action::Upload
        end
      end

      def self.chef_zero_clean
        Vagrant::Action::Builder.new.tap do |b|
          b.use VagrantPlugins::ChefZero::Action::Stop
        end
      end

      def self.setup
        ::Vagrant::Action::Builder.new.tap do |b|
          b.use ::Vagrant::Action::Builtin::EnvSet, chef_zero: VagrantPlugins::ChefZero::Env.new
        end
      end

    end
  end
end

module VagrantPlugins
  module Chef
    module Config
      class ChefClient

        old_validate = ObjectSpace.each_object(VagrantPlugins::Chef::Config::ChefClient).first.method(:validate)
        def validate(machine)
          old_validate(machine)
        end

      end
    end
  end
end