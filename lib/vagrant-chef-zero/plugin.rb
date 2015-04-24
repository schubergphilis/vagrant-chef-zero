require 'ridley'

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.2.0"
  raise "The Vagrant Chef Zero plugin is only compatible with Vagrant 1.2+"
end

module VagrantPlugins
  module ChefZero
    class Plugin < Vagrant.plugin("2")

      class << self
        def reconfig(hook)
          hook.before(::Vagrant::Action::Builtin::ConfigValidate, VagrantPlugins::ChefZero::Action.chef_zero_ui_setup)
          hook.before(::Vagrant::Action::Builtin::ConfigValidate, VagrantPlugins::ChefZero::Action.chef_zero_reconfig)
        end

        def provision(hook)
          hook.before(::Vagrant::Action::Builtin::Provision, VagrantPlugins::ChefZero::Action.chef_zero_provision)
        end

        def destroy(hook)
          hook.after(::Vagrant::Action::Builtin::ConfigValidate, VagrantPlugins::ChefZero::Action.chef_zero_destroy)
        end

      end

      name "chef_zero"
      description <<-DESC
      This plugin adds configuration options to allow Vagrant to interact with
      Chef Zero
      DESC

      # Deep magic of not binding to any specific action.. so we can bind to them all
      action_hook(:chef_zero_reconfig, &method(:reconfig))

      action_hook(:chef_zero_up, :machine_action_up, &method(:provision))

      action_hook(:chef_zero_reload, :machine_action_reload, &method(:provision))

      action_hook(:chef_zero_provision, :machine_action_provision, &method(:provision))

      action_hook(:chef_zero_provision, :machine_action_reload, &method(:provision))

      action_hook(:chef_zero_destroy, :machine_action_destroy, &method(:destroy))

      config(:chef_zero) do
        require_relative "config"
        Config
      end

    end
  end
end
