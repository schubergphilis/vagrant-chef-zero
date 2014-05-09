module VagrantPlugins
  module ChefZero
    module Action

      class Reconfig

        include VagrantPlugins::ChefZero::EnvHelpers
        include VagrantPlugins::ChefZero::ServerHelpers

        def initialize(app, env)
          @app = app

          if chef_zero_enabled?(env)
            @key = get_key_path(env)
            set_config("@validation_key_path", @key, env)

            @chef_server_url = get_chef_server_url(env)
            set_config("@chef_server_url", @chef_server_url, env)

            @validation_client_name = get_validation_client_name(env)
            set_config("@validation_client_name", @validation_client_name, env)

            write_knife_config(env)
          end

          # if berkshelf_enabled?(env)
          #   @key = get_key_path(env)
          #   set_berkshelf_client_key(@key)
          # end
        end

        def call(env)
          @app.call(env)
        end

      end

    end
  end
end
