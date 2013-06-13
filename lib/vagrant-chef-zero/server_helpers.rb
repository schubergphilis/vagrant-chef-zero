module VagrantPlugins
  module ChefZero
    module ServerHelpers

      def start_chef_zero(env)
        port = get_port(env)
        host = get_host(env)
        if ! chef_zero_server_running?(port)
          proc = IO.popen("chef-zero --host #{host} --port #{port} 2>&1 > /dev/null")
        end
        while ! chef_zero_server_running?(port)
          sleep 1
        end
      end

      def stop_chef_zero(env)
        port = get_port(env)
        if chef_zero_server_running?(port)
          pid = get_chef_zero_server_pid(port)
          system("kill #{pid}")
        end
      end

      def chef_zero_server_running?(port)
        pid = get_chef_zero_server_pid(port)
        !! pid
      end

      def get_chef_zero_server_pid(port)
        pid = %x[ lsof -i tcp:#{port} | grep ruby | awk '{print $2}' ]
        if pid && pid != ""
          return pid
        end
        return nil
      end

    end
  end
end