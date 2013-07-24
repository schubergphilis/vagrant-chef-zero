require 'simplecov'
SimpleCov.formatter = SimpleCov::Formatter::SimpleFormatter
SimpleCov.start

require_relative "../lib/vagrant-chef-zero"
require_relative "../lib/vagrant-chef-zero/server_helpers.rb"
require_relative "../lib/vagrant-chef-zero.rb"

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require 'mocha/setup' # This should be after any minitest requires
require 'turn'
require 'json'

Turn.config do |c|
  # :outline  - turn's original case/test outline mode [default]
  c.format  = :outline
  # use humanized test names (works only with :outline format)
  c.natural = true
end