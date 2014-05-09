source "https://rubygems.org"

gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", :git => "git://github.com/mitchellh/vagrant.git", :tag => "v1.5.4"
  gem "debugger"
  gem "vagrant-berkshelf", ">= 1.3.3"
end

# Force Vagrant to load our plugin during development
group :plugins do
    gem "vagrant-chef-zero", :path => "/Users/awgross/dev/andrew/vagrant-chef-zero"
end
