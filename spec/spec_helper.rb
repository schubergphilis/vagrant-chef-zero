require 'simplecov'
SimpleCov.formatter = SimpleCov::Formatter::SimpleFormatter
SimpleCov.start

require_relative "../lib/vagrant-chef-zero"
require_relative "../lib/vagrant-chef-zero/server_helpers.rb"
require_relative "../lib/vagrant-chef-zero.rb"

require 'json'