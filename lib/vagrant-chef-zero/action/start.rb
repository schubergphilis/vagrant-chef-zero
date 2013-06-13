module VagrantPlugins
  module ChefZero
    module Action

      class Start

        include VagrantPlugins::ChefZero::EnvHelpers

        def initialize(app, env)
          @app = app
          @host = get_host_ip(server_info(env)[:host])
          @port = get_port(server_info(env)[:host])
          @key = get_key_path(env)
          set_config("@validation_key_path", @key, env)
          @pid = nil
        end

        def call(env)
          proc = IO.popen("chef-zero --host #{@host} --port #{@port} 2>&1 > /dev/null")
          @pid = proc.pid
          @app.call(env)
        end

        private

          def get_host_ip(url)
            if url
              # Some terrible string manipulation to get the ip
              return url.split('//').last.split(':').first
            else
              return "127.0.0.1"
            end
          end

          def get_port(url)
            # Same with the port
            if ! url
              return 4000
            end

            p = url.split(':').last.to_i
            if p != 0
              port = p
            else
              port = 4000
            end
            port
          end

      end

    end
  end
end