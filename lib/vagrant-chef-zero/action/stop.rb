module VagrantPlugins
  module ChefZero
    module Action

      class Stop

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
          stop_chef_zero(env)
          @app.call(env)
        end

      end

    end
  end
end