begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant Chef-Zero plugin must be run within Vagrant."
end

module VagrantPlugins
  module ChefZero
    autoload :Action, 'vagrant-chef-zero/action'
    autoload :Config, 'vagrant-chef-zero/config'
    autoload :Env, 'vagrant-chef-zero/env'
  end
end

require "vagrant-chef-zero/plugin"
