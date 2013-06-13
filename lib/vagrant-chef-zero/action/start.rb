module VagrantPlugins
  module ChefZero
    module Action

      class Start

        include VagrantPlugins::ChefZero::EnvHelpers
        include VagrantPlugins::ChefZero::ServerHelpers

        def initialize(app, env)
          @app = app
          @key = get_key_path(env)
          set_config("@validation_key_path", @key, env)
          @pid = nil
        end

        def call(env)
          start_chef_zero(env)
          @app.call(env)
        end

      end

    end
  end
end