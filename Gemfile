source "https://rubygems.org"

gem 'json', '~> 1.7.7'

gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", :git => "git://github.com/mitchellh/vagrant.git"
  gem "debugger"
  gem "vagrant-berkshelf", ">= 1.3.3"
end
