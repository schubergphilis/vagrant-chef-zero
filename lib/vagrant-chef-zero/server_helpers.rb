require 'vagrant/util'

module VagrantPlugins
  module ChefZero
    module ServerHelpers

      def start_chef_zero(env)
        require 'chef_zero/server'

        port = get_port(env)
        host = get_host(env)

        unless chef_zero_server_running?(host, port)
          chef_zero_binary = get_chef_zero_binary(env)
          fork_process(chef_zero_binary, host, port, env)
          wait_for_server_to_start(host, port, env)
        end
      end

      def get_chef_zero_binary(env)
        # We want to prefer the vagrant.d path, but for development
        # we want to find any valid path that has chef-zero
        paths = Gem.path
        vagrant_path = paths.select { |gp| gp.include?('vagrant.d')}.first
        if has_chef_zero_binary?(vagrant_path)
          return find_chef_zero_binary(vagrant_path)
        end
        paths.each do |path|
          if has_chef_zero_binary?(path)
            return find_chef_zero_binary(path)
          end
        end
        env[:chef_zero].ui.warn("Could not find Chef Zero binary in any path in #{Gem.path}")
        raise
      end

      def has_chef_zero_binary?(path)
        potential_binary = find_chef_zero_binary(path)
        if potential_binary
          return ::File.exists?(potential_binary)
        else
          return false
        end
      end

      def find_chef_zero_binary(path)
        # Assuming a path from Gem.path
        if path == nil
          return nil
        end
        gems_path = ::File.join(path, "gems")
        chef_zero_gem = Dir["#{gems_path}/*"].select { |gp| gp.include?('/chef-zero-')}.first
        if chef_zero_gem
          return ::File.join(chef_zero_gem, "bin", "chef-zero")
        else
          return nil
        end
      end

      def fork_process(command, host, port, env)
        ruby_bin = Pathname.new(Vagrant::Util::Which.which("ruby")).to_s
        pid = Process.spawn("#{ruby_bin} #{command} --host #{host} --port #{port}",
                            :out=>File::NULL, :err=>File::NULL)
        Process.detach pid
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
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ENETUNREACH
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
        system("kill -s TERM #{pid}")
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
