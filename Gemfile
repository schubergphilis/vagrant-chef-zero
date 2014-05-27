source "https://rubygems.org"

gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", :git => "git://github.com/mitchellh/vagrant.git", :tag => "v1.6.2"
  gem "vagrant-berkshelf", ">= 2.0.1"

  gem "mocha"
  gem "simplecov"
  gem "rake"
  gem "rspec"

end

# Force Vagrant to load our plugin during development (assume we are running from top level)
group :plugins do
  gem "vagrant-chef-zero", :path => Dir.pwd
end
