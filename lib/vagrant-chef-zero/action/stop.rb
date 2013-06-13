module VagrantPlugins
  module ChefZero
    module Action

      class Stop

        include VagrantPlugins::ChefZero::EnvHelpers

        def initialize(app, env)
          @app = app
          @key = get_key_path(env)
          set_config("@validation_key_path", @key, env)
        end

        def call(env)
          stop_chef_zero(env)
        end

        def stop_chef_zero(env)
          port = server_info(env)[:host].split(':').last
          pid = %x[ lsof -i tcp:#{port} | grep ruby | awk '{print $2}' ]
          system("kill #{pid}")
        end

      end

    end
  end
end