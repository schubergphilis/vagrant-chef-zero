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