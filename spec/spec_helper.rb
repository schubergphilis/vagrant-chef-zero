require 'json'
require 'simplecov'
require 'coveralls'

require_relative "../lib/vagrant-chef-zero"
require_relative "../lib/vagrant-chef-zero/server_helpers.rb"
require_relative "../lib/vagrant-chef-zero.rb"

RSpec.configure do |c|
  c.expect_with(:rspec) { |c| c.syntax = :should }
end

SimpleCov.formatter = SimpleCov::Formatter::SimpleFormatter
SimpleCov.start
Coveralls.wear!
