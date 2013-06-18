require 'ridley'

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.2.0"
  raise "The Vagrant Chef Zero plugin is only compatible with Vagrant 1.2+"
end

module VagrantPlugins
  module ChefZero
    class Plugin < Vagrant.plugin("2")
      name "chef_zero"
      description <<-DESC
      This plugin adds configuration options to allow Vagrant to interact with
      Chef Zero
      DESC


      class << self
        def provision(hook)
          hook.before(::Vagrant::Action::Builtin::ConfigValidate, VagrantPlugins::ChefZero::Action.setup)
          hook.after(::Vagrant::Action::Builtin::Provision, VagrantPlugins::ChefZero::Action.chef_zero_provision)
        end

        def clean(hook)
          hook.after(VagrantPlugins::ProviderVirtualBox::Action::DestroyUnusedNetworkInterfaces, VagrantPlugins::ChefZero::Action.chef_zero_clean)
        end
      end

      action_hook(:chef_zero_up, :machine_action_up, &method(:provision))
      # action_hook(:chef_zero_provision, :machine_action_reload, &method(:provision))
      action_hook(:chef_zero_provision, :machine_action_provision, &method(:provision))

      action_hook(:chef_zero_provision, :machine_action_reload, &method(:provision))

      action_hook(:chef_zero_clean, :machine_action_destroy, &method(:clean))

      config(:chef_zero) do
        require_relative "config"
        Config
      end

    end
  end
end