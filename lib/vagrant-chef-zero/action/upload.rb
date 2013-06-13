module VagrantPlugins
  module ChefZero
    module Action

      class Upload

        include VagrantPlugins::ChefZero::EnvHelpers
        include VagrantPlugins::ChefZero::ServerHelpers

        def initialize(app, env)
          @conn = nil
          @app = app
          @url = server_info(env)[:host]
          @client_name = server_info(env)[:client_name]
          @client_key = server_info(env)[:client_key]
        end

        def call(env)
          setup_connection
          upload_cookbooks(env)
          upload_environments(env)
          upload_roles(env)
          upload_nodes(env)
          upload_data_bags(env)
          @app.call(env)
        end

        def upload_cookbooks(env)
          path = env[:machine].config.chef_zero.cookbooks
          env[:ui].info("Loading cookbooks from #{path}")
          existing_cookbooks = @conn.node.all

          if path
            cookbooks = Dir.glob(path)
            cookbooks.each do |c|
            cookbook = JSON.parse(IO.read(c)).to_hash
              if ! existing_cookbooks.any?{ |e| e['name'] == cookbook['name'] }
                @conn.cookbook.create(cookbook)
              else
                @conn.cookbook.update(cookbook)
              end
            end
          end
        end

        def upload_nodes(env)
          path = env[:machine].config.chef_zero.nodes
          existing_nodes = @conn.node.all

          if path
            nodes = Dir.glob(path)
            nodes.each do |n|
            node = JSON.parse(IO.read(n)).to_hash
              if ! existing_nodes.any?{ |e| e['name'] == node['name'] }
                @conn.node.create(node)
              else
                @conn.node.update(node)
              end
            end
          end
        end

        def upload_environments(env)
          path = env[:machine].config.chef_zero.environments
          existing_envs = @conn.environment.all

          if path
            environments = Dir.glob(path)
            environments.each do |e|
              environment = JSON.parse(IO.read(e)).to_hash
              if ! existing_envs.any?{ |ee| ee['name'] == environment['name'] }
                @conn.environment.create(environment)
              else
                @conn.environment.update(environment)
              end
            end
          end
        end

        def upload_roles(env)
          path = env[:machine].config.chef_zero.roles
          existing_roles = @conn.role.all

          if path
            roles = Dir.glob(path)
            roles.each do |r|
            role = JSON.parse(IO.read(r)).to_hash
              if ! existing_roles.any?{ |er| er['name'] == role['name'] }
                @conn.role.create(role)
              else
                @conn.role.update(role)
              end
            end
          end
        end

        def upload_data_bags(env)
          path = env[:machine].config.chef_zero.data_bags

          if path
            data_bags = Dir.glob(path).select{|d| File.directory? d}

            data_bags.each do |data_bag_dir|
              bag_name = File.basename data_bag_dir
              data_bag = @conn.data_bag.find(bag_name)
              if ! data_bag
                data_bag = create_data_bag(bag_name)
              end

              Dir.glob("#{data_bag_dir}/*.json").each do |i|
                item_as_hash = JSON.parse(IO.read(i)).to_hash
                if data_bag.item.find(item_as_hash['id'])
                  update_data_bag_item(data_bag, item_as_hash)
                else
                  create_data_bag_item(data_bag, item_as_hash)
                end
              end
            end
          end
        end

        def setup_connection
          if ! @conn
            require 'ridley'
            @conn = Ridley.new(server_url: @url,
                            client_name: @client_name,
                            client_key: @client_key)
          end
          @conn
        end

      end

    end
  end
end