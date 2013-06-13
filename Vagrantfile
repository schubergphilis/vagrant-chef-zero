require 'socket'

ip_address = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address

Vagrant.require_plugin "vagrant-chef-zero"

Vagrant.configure("2") do |config|
  config.vm.box = ENV['YIPIT_VAGRANT_BOX']
  config.chef_zero.nodes = "foobar"
  config.chef_zero.environments = "foobar"
  config.chef_zero.data_bags = "foobar"
  config.chef_zero.cookbooks = "foobar"
  config.chef_zero.roles = "foobar"

  config.vm.provision :chef_client do |chef|
    chef.json = { "username" => "vagrant" }

    chef.chef_server_url = "http://#{ip_address}:4000"
    chef.validation_client_name = "chef-validator"

    chef.log_level = "debug"

    chef.run_list = [
       "recipe[yipit_helper_libraries::test]"
    ]
  end
end