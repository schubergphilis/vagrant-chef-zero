$:.unshift File.expand_path("../lib", __FILE__)
require "vagrant-chef-zero/version"

Gem::Specification.new do |s|
  s.name          = "vagrant-chef-zero"
  s.version       = VagrantPlugins::ChefZero.get_version()
  s.platform      = Gem::Platform::RUBY
  s.authors       = "Andrew Gross"
  s.email         = "andrew.w.gross@gmail.com"
  s.homepage      = "http://github.com/andrewgross/vagrant-chef-zero"
  s.summary       = "Enables Vagrant to interact with Chef Zero."
  s.description   = "Enables Vagrant to interact with Chef Zero"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "vagrant-chef-zero"
  s.license = "MIT"

  s.add_dependency "chef-zero", "~> 2.0"
  s.add_dependency "ridley", ">= 1.0.0"
  s.add_dependency "chef", "~> 11.0"

  s.add_development_dependency "bump", "~> 0.5.2"

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
end
