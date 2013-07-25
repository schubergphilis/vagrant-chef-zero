require_relative 'errors'

module VagrantPlugins
  module ChefZero
    class Command < Vagrant.plugin("2", "command")

      include VagrantPlugins::ChefZero::EnvHelpers
      include VagrantPlugins::ChefZero::ServerHelpers

      def execute
        mock_env = {}
        machine = @env.machine(:default, :virtualbox)
        mock_env[:machine] = machine
        command = parse(@argv)
        dispatch(command, mock_env)
      end

      def check_param(command)
        options = ['start', 'stop', 'status']
        usage = "Usage vagrant chef-zero [start|status|stop]"
        raise VagrantPlugins::ChefZero::VagrantWrapperError, usage unless command.length == 1
        raise VagrantPlugins::ChefZero::VagrantWrapperError, usage unless options.include?(command.first)
      end

      def dispatch(command, env)
        if command == "start"
          start_chef_zero(env)
        elsif command == "stop"
          stop_chef_zero(env)
        elsif command == "status"
          #status
        end
      end

      def parse(args)
        check_param(args)
        command = args.first
        command
      end

      private

        def start
          require 'debugger';debugger
          start_chef_zero(@env)
        end

        def stop
          stop_chef_zero(@env)
        end

        def status
        end

    end
  end
end