module VagrantPlugins
  module ChefZero
    module ServerHelpers

      def start_chef_zero(env)
        require 'chef_zero/server'

        unless env[:chef_zero].server && env[:chef_zero].server.running?
          port = get_port(env)
          host = get_host(env)

          env[:chef_zero].server = ::ChefZero::Server.new(host: host, port: port)
          env[:chef_zero].server.start_background
          env[:chef_zero].ui.info("Starting Chef Zero at http://#{host}:#{port}")

          until env[:chef_zero].server.running?
            sleep 1
            env[:chef_zero].ui.warn("Waiting for Chef Zero to start")
          end
        end
      
      end

      def stop_chef_zero(env)    
        if env[:chef_zero].server && env[:chef_zero].server.running?
          env[:chef_zero].ui.info("Stopping Chef Zero")
          env[:chef_zero].server.stop
        end
      end
    end
  end
end
