$:.unshift File.expand_path("../lib", __FILE__)
require "vagrant-chef-zero/version"

Gem::Specification.new do |s|
  s.name          = "vagrant-chef-zero"
  s.version       = VagrantPlugins::ChefZero.get_version()
  s.platform      = Gem::Platform::RUBY
  s.authors       = "Andrew Gross, Miguel Ferreira, Timothy van Zadelhoff"
  s.email         = "andrew.w.gross@gmail.com, miguelferreira@me.com"
  s.homepage      = "http://github.com/schubergphilis/vagrant-chef-zero"
  s.summary       = "Enables Vagrant to spawn a Chef Zero instance that is shared by all VMs."
  s.description   = "Enables Vagrant to spawn a Chef Zero instance that is shared by all VMs."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "vagrant-chef-zero"
  s.license = "Apache v2.0"

  s.add_dependency "chef-zero", "~> 2.0"
  s.add_dependency "ridley", ">= 1.0.0"
  s.add_dependency "chef", "~> 11.0"

  s.add_development_dependency "bump", "~> 0.5.2"

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
end
