module VagrantPlugins
  module ChefZero
    module Action

      class Start

        include VagrantPlugins::ChefZero::EnvHelpers
        include VagrantPlugins::ChefZero::ServerHelpers

        def initialize(app, env)
          @app = app
          @key = get_key_path(env)
        end

        def call(env)
          unless chef_zero_enabled?(env)
            return @app.call(env)
          end

          start_chef_zero(env)
          write_knife_config(env)

          @app.call(env)
        end

      end

    end
  end
end
