source "https://rubygems.org"

gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", :git => "git://github.com/mitchellh/vagrant.git", :tag => "v2.0.4"

  gem 'coveralls', require: false

  gem "mocha"
  gem "simplecov"
  gem "rake"
  gem "rspec"

end

# Windows platform requirements to run chef-zero
group :windows do
  gem "ruby-wmi"
  gem "win32-service"
end if (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|ming32/)

# Force Vagrant to load our plugin during development (assume we are running from top level)
group :plugins do
  gem "vagrant-berkshelf", ">= 2.0.1"
  gemspec
end
