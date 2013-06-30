module VagrantPlugins
  module ChefZero
    module EnvHelpers

      def write_knife_config(env)
        File.open("#{env[:root_path]}/.zero-knife.rb", 'w') do |f|
          f.puts <<-EOF
            chef_server_url '#{get_chef_server_url(env)}'
            node_name 'zero-host'
            client_key '#{get_key_path(env)}'
          EOF
        end
      end

      def rm_knife_config(env)
        File.rm "#{env[:root_path]}/.zero-knife.rb"
        File.rm get_key_path(env)
      end

      def server_info(env)
        dict = { host: nil, client_name: nil, client_key: nil }
        provisioners(:chef_client, env).each do |provisioner|
          host = provisioner.config.chef_server_url ||= nil
          client_name = provisioner.config.validation_client_name ||= nil
          client_key = provisioner.config.validation_key_path ||= nil
          dict = { host: host, client_name: client_name, client_key: client_key }
        end
        dict
      end

      def set_config(config_field, new_value, env)
        provisioners(:chef_client, env).each do |provisioner|
          provisioner.config.instance_variable_set(config_field, new_value)
        end
      end

      def provisioners(name, env)
        env[:machine].config.vm.provisioners.select { |prov| prov.name == name }
      end

      def get_validation_client_name(env)
        current_client_name = server_info(env)[:client_name]
        if ! current_client_name || current_client_name.empty?
          current_client_name = "dummy-validator"
        end
        current_client_name
      end

      def get_chef_server_url(env)
        current_chef_server_url = server_info(env)[:host]
        if ! current_chef_server_url || current_chef_server_url.empty?
          require 'socket'
          ip_address = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
          current_chef_server_url = "http://#{ip_address}:4000"
        end
        current_chef_server_url
      end

      def get_key_path(env)
        current_key_path = server_info(env)[:client_key]
        if ! current_key_path || ! ::File.exists?(current_key_path)
          current_key_path = get_fake_key_path
        end
        current_key_path
      end

      def get_fake_key_path
        require 'openssl'
        require 'tmpdir'
        fake_key = OpenSSL::PKey::RSA.new(2048)
        fake_directory = File.join(Dir.tmpdir, "fake_key")
        fake_key_path = File.join(fake_directory, "fake.pem")
        Dir.mkdir(fake_directory) unless File.exists?(fake_directory)
        File.open(fake_key_path,"w") {|f| f.puts fake_key } unless File.exists?(fake_key_path)
        fake_key_path
      end

      def get_host(env)
        url = server_info(env)[:host]
        if url
          # Some terrible string manipulation to get the ip
          return url.split('//').last.split(':').first
        end
      end

      def get_port(env)
        url = server_info(env)[:host]
        # Same with the port
        if url
          p = url.split(':').last
          if p && p != ""
            port = p
          end
        else
          port = "4000"
        end
        port
      end

      def chef_client?(env)
        provisioners(:chef_client, env).any?
      end

      def chef_zero_enabled?(env)
        env[:global_config].chef_zero.enabled && chef_client?(env)
      end

    end
  end
end
