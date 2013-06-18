require 'vagrant/action/builder'
require 'vagrant-chef-zero/env_helpers'
require 'vagrant-chef-zero/server_helpers'

module VagrantPlugins
  module ChefZero
    module Action

      include Vagrant::Action::Builtin

      autoload :Reconfig, 'vagrant-chef-zero/action/reconfig'
      autoload :Start,    'vagrant-chef-zero/action/start'
      autoload :Upload,   'vagrant-chef-zero/action/upload'
      autoload :Stop,     'vagrant-chef-zero/action/stop'

      def self.chef_zero_provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use VagrantPlugins::ChefZero::Action::Start
          b.use VagrantPlugins::ChefZero::Action::Upload
        end
      end

      def self.chef_zero_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use VagrantPlugins::ChefZero::Action::Stop
        end
      end

      def self.chef_zero_reconfig
        Vagrant::Action::Builder.new.tap do |b|
          b.use VagrantPlugins::ChefZero::Action::Reconfig
        end
      end

      def self.chef_zero_ui_setup
        Vagrant::Action::Builder.new.tap do |b|
          b.use ::Vagrant::Action::Builtin::EnvSet, chef_zero: VagrantPlugins::ChefZero::Env.new
        end
      end

    end
  end
end