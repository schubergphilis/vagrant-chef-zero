module VagrantPlugins
  module ChefZero
    module ServerHelpers

      def start_chef_zero(env)
        require 'chef_zero/server'

        port = get_port(env)
        host = get_host(env)

        unless chef_zero_server_running?(host, port)
          vagrant_gems = ENV['GEM_PATH'].split(':').select { |gp| gp.include?('vagrant.d')}.first
          chef_zero_binary = ::File.join(vagrant_gems, "bin", "chef-zero")
          fork_process(chef_zero_binary, host, port, env)
          wait_for_server_to_start(host, port, env)
        end
      end

      def fork_process(command, host, port, env)
        IO.popen("#{command} --host #{host} --port #{port} 2>&1 > /dev/null")
        env[:chef_zero].ui.info("Starting Chef Zero at http://#{host}:#{port}")
      end

      def wait_for_server_to_start(host, port, env)
        until chef_zero_server_running?(host, port)
          sleep 1
          env[:chef_zero].ui.warn("Waiting for Chef Zero to start")
        end
      end

      def chef_zero_server_running?(host, port)
        timeout = 0.5 # Seconds
        Timeout::timeout(timeout) do
          return port_open?(host, port) && is_a_chef_zero_server?(host, port)
        end
      rescue Timeout::Error
        false
      end

      def is_a_chef_zero_server?(host, port)
        require "net/http"
        require "uri"
        # Seems silly to rebuild the URI after deconstructing it earlier
        uri = URI::HTTP.build({ :host => host, :port => port.to_i, :path => "/"})
        http = Net::HTTP.new(uri.host, uri.port)
        http.open_timeout = 0.5 # Seconds
        http.read_timeout = 0.5 # Seconds
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        return response['server'] == "chef-zero"
      end

      # Taken from SO, http://stackoverflow.com/questions/517219/ruby-see-if-a-port-is-open
      def port_open?(ip, port, seconds=0.5)
        begin
          TCPSocket.new(ip, port).close
          true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          false
        end
      end

      def stop_chef_zero(env)
        host = get_host(env)
        port = get_port(env)
        if chef_zero_server_running?(host, port)
          pid = get_chef_zero_server_pid(port)
          if pid
            kill_process(env, pid)
          end
        end
      end

      def kill_process(env, pid)
        env[:chef_zero].ui.info("Stopping Chef Zero")
        system("kill -s SIGTERM #{pid}")
      end

      def get_chef_zero_server_pid(port)
        pid = %x[ lsof -i tcp:#{port} | grep -E 'ruby|chef-zero' | awk '{print $2}' ]
        if pid && pid != ""
          return pid
        else
          return false
        end
      end

    end
  end
end
