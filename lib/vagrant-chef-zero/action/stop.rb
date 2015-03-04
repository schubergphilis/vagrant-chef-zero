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
          EnvHelpers.mutex.synchronize do
            active = EnvHelpers.active_machines(env)
            active.delete_if do |name, provider|
              name == env[:machine].name
            end
            unless active.empty?
              return @app.call(env)
            end
          end
          stop_chef_zero(env)
          rm_knife_config(env)

          @app.call(env)
        end

      end

    end
  end
end
