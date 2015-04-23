source "https://rubygems.org"

gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", :git => "git://github.com/mitchellh/vagrant.git", :tag => "v1.7.2"

  gem "mocha"
  gem "simplecov"
  gem "rake"
  gem "rspec"

end

# Windows platform requirements to run chef-zero
platforms :mswin, :mingw do
  gem "ruby-wmi"
  gem "win32-service"
end

# Force Vagrant to load our plugin during development (assume we are running from top level)
group :plugins do
  gem "vagrant-berkshelf", ">= 2.0.1"
  gem "vagrant-chef-zero", :path => Dir.pwd
end
