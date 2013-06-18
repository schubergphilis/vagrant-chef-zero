require 'socket'

ip_address = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address

Vagrant.require_plugin "vagrant-chef-zero"

Vagrant.configure("2") do |config|

  config.chef_zero.nodes =        "spec/vagrant-chef-zero/fixtures/nodes"
  config.chef_zero.environments = "spec/vagrant-chef-zero/fixtures/environments"
  config.chef_zero.data_bags =    "spec/vagrant-chef-zero/fixtures/data_bags"
  config.chef_zero.cookbooks =    "spec/vagrant-chef-zero/fixtures/cookbooks"
  config.chef_zero.roles = "foobar"

  config.vm.box = ENV['YIPIT_VAGRANT_BOX']
  config.vm.provision :chef_client do |chef|
    chef.json = { "username" => "vagrant" }

    chef.chef_server_url = "http://#{ip_address}:4000"
    chef.validation_client_name = "chef-validator"

    chef.run_list = [
    ]
  end
end
