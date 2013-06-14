Note: At this time the gem version is doing some weird stuff when installed by Vagrant.  If you want to play with this you will need to download the Git repo and use the bundler version of Vagrant for development.

# Vagrant-Chef-Zero

This is a plugin designed to help integrate Chef-Zero into a Vagrant run, similar to Berkshelf.  Chef-Zero will be started on the host machine and populated with the specified data.  When the Vagrant machine is destroyed Chef-Zero will be killed.

## Configuration

Inside of your Vagrant file you will have access to the following configuration options:

```ruby
config.chef_zero.nodes = "../foobar/nodes"
config.chef_zero.environments = "../foobar/environments"
config.chef_zero.data_bags = "../foobar/data_bags"
config.chef_zero.roles = "../foobar/roles"
```

As Vagrant is booting up, `vagrant-chef-zero` will search each specified location for files to upload to Chef-Zero.  The upload will be done via Ridley APIs.

## Cookbooks

For V1 we will rely on you having Berkshelf upload these, but it can be addressed later.

## Authentication

None! `vagrant-chef-zero` performs some ruby black magic to generate a fake RSA key and patch it in to the `chef-client` configuration.  You should not need to worry about providing `validation_key_path`.

## Chef Server URL

Currently relies on the `chef_server_url` parameter. In the future this should also be ignorable similar to `validation_key_path`.  The address provided for your server should not be `127.0.0.1` as Chef-Zero is on the host.  Ideally the IP address of the host machine will be used.

## Validation Client Name

Still required for now, should be ignoreable in the future.

