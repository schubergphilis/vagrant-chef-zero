Vagrant.configure("2") do |config|

  config.chef_zero.nodes =        "spec/vagrant-chef-zero/fixtures/nodes"
  config.chef_zero.environments = "spec/vagrant-chef-zero/fixtures/environments"
  config.chef_zero.data_bags =    "spec/vagrant-chef-zero/fixtures/data_bags"
  config.chef_zero.cookbooks =    "spec/vagrant-chef-zero/fixtures/cookbooks"
  config.chef_zero.roles = "foobar"

  config.vm.box = 'precise64.box'
  config.vm.provision :chef_client do |chef|
    chef.run_list = [
    ]
  end
end
