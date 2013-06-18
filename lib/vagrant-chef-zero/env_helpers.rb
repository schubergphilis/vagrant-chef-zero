module VagrantPlugins
  module ChefZero
    module EnvHelpers

      def server_info(env)
        provisioners(:chef_client, env).each do |provisioner|
          return { host: provisioner.config.chef_server_url,
                   client_name: provisioner.config.validation_client_name,
                   client_key: provisioner.config.validation_key_path }
        end
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
        p = url.split(':').last
        if p && p != ""
          port = p
        else
          port = "4000"
        end
        port
      end

    end
  end
end