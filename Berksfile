# -*- Mode: ruby; -*-
chef_api "https://api.opscode.com/organizations/yipit_staging", node_name: "yipit", client_key: "#{ENV['CHEF_PATH']}/staging/yipit.pem"
site :opscode
#metadata

## If you feel like trying to use a local cookbook while you're locally
## developing, you just need to add a line in the following format:
#
# cookbook '<name-of-the-cookbook>', path: '/absolute/path/to/the/cookbook'

group :test do
  cookbook 'minitest-handler'
  cookbook 'apt'
end
