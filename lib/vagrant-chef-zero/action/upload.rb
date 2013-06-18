module VagrantPlugins
  module ChefZero
    module Action

      class Upload

        include VagrantPlugins::ChefZero::EnvHelpers
        include VagrantPlugins::ChefZero::ServerHelpers

        def initialize(app, env)
          @conn = nil
          @app = app
          @env = env
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
          cookbooks = select_items(path)
          env[:chef_zero].ui.info("Loading cookbooks from #{path}") unless cookbooks.empty?
          cookbooks.each do |cookbook|
            name = File.basename(cookbook)
            env[:chef_zero].ui.info("Uploading Cookbook #{name}")
            @conn.cookbook.upload(cookbook, options: {name: name})
          end
        end

        def upload_nodes(env)
          path = env[:machine].config.chef_zero.nodes
          existing_nodes = @conn.node.all

          nodes = select_items(path)
          nodes.each do |n|
            node = JSON.parse(IO.read(n)).to_hash
            if ! existing_nodes.any?{ |e| e['name'] == node['name'] }
              env[:chef_zero].ui.info("Creating Node #{node['name']}")
              @conn.node.create(node)
            else
              env[:chef_zero].ui.info("Updating Node #{node['name']}")
              @conn.node.update(node)
            end
          end
        end

        def upload_environments(env)
          path = env[:machine].config.chef_zero.environments
          existing_envs = @conn.environment.all

          environments = select_items(path)
          environments.each do |e|
            environment = JSON.parse(IO.read(e)).to_hash
            if ! existing_envs.any?{ |ee| ee['name'] == environment['name'] }
              env[:chef_zero].ui.info("Creating Environment #{environment['name']}")
              @conn.environment.create(environment)
            else
              env[:chef_zero].ui.info("Updating Environment #{environment['name']}")
              @conn.environment.update(environment)
            end
          end
        end

        def upload_roles(env)
          path = env[:machine].config.chef_zero.roles
          existing_roles = @conn.role.all

          roles = select_items(path)
          roles.each do |r|
          role = JSON.parse(IO.read(r)).to_hash
            if ! existing_roles.any?{ |er| er['name'] == role['name'] }
              env[:chef_zero].ui.info("Creating role #{role['name']}")
              @conn.role.create(role)
            else
              env[:chef_zero].ui.info("Updating role #{role['name']}")
              @conn.role.update(role)
            end
          end
        end

        def upload_data_bags(env)
          path = env[:machine].config.chef_zero.data_bags
          if path && File.directory?(path)
            data_bags = Dir.glob("#{path}/*").select{|d| File.directory? d}

            data_bags.each do |data_bag_dir|
              bag_name = File.basename(data_bag_dir)
              data_bag = @conn.data_bag.find(bag_name)
              if ! data_bag
                env[:chef_zero].ui.info("Creating Data Bag #{bag_name}")
                data_bag = @conn.data_bag.create(name: bag_name)
              end

              Dir.glob("#{data_bag_dir}/*.json").each do |i|
                item_as_hash = JSON.parse(IO.read(i)).to_hash
                if data_bag.item.find(item_as_hash['id'])
                  env[:chef_zero].ui.info("Updating item #{item_as_hash['id']} in Data Bag #{bag_name}")
                  data_bag.item.update(item_as_hash)
                else
                  env[:chef_zero].ui.info("Creating item #{item_as_hash['id']} in Data Bag #{bag_name}")
                  data_bag.item.create(item_as_hash)
                end
              end
            end
          end
        end

        def select_items(path)
          if path.nil? || path.empty?
            path = []
          elsif path.is_a?(Array)
            path
          elsif File.directory?(path)
            path = Dir.glob("#{path}/*.json")
          elsif File.exists?(path)
            path = [path]
          else
            @env[:chef_zero].ui.warn("Warning: Unable to normalize #{path}, skipping")
            path = []
          end
          path
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