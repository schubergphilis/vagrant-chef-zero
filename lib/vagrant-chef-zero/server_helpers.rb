module VagrantPlugins
  module ChefZero
    module ServerHelpers

      def chef_zero_binary
        gem_dirs = ENV['GEM_PATH'].split(':')
        test_paths = gem_dirs.map { |d| ::File.join(d, "bin", "chef-zero") }
        found = test_paths.select { |f| ::File.executable?(f) }
        found.first if found.size > 0
      end

      def start_chef_zero(env)
        port = get_port(env)
        host = get_host(env)
        if ! chef_zero_server_running?(port)
          env[:chef_zero].ui.info("Using chef-zero binary: '#{chef_zero_binary}'")
          proc = IO.popen("#{chef_zero_binary} --host #{host} --port #{port} 2>&1 > /dev/null")
          env[:chef_zero].ui.info("Starting Chef Zero at http://#{host}:#{port}")
        end
        while ! chef_zero_server_running?(port)
          sleep 1
          env[:chef_zero].ui.warn("Waiting for Chef Zero to start")
        end
      end

      def stop_chef_zero(env)
        port = get_port(env)
        if chef_zero_server_running?(port)
          pid = get_chef_zero_server_pid(port)
          env[:chef_zero].ui.info("Stopping Chef Zero")
          system("kill #{pid}")
        end
      end

      def chef_zero_server_running?(port)
        pid = get_chef_zero_server_pid(port)
        !! pid
      end

      def get_chef_zero_server_pid(port)
        pid = %x[ lsof -i tcp:#{port} | grep -E 'ruby|chef-zero' | awk '{print $2}' ]
        if pid && pid != ""
          return pid
        end
        return nil
      end

    end
  end
end
