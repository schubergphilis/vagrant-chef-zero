module VagrantPlugins
  module ChefZero
    module Action

      class Reconfig

        include VagrantPlugins::ChefZero::EnvHelpers
        include VagrantPlugins::ChefZero::ServerHelpers

        def initialize(app, env)
          @app = app
          @key = get_key_path(env)
          set_config("@validation_key_path", @key, env)
        end

        def call(env)
          @app.call(env)
        end

      end

    end
  end
end