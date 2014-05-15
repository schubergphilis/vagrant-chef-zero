
NOTE: This version (`0.5.0`) is in beta status as I have not had time to fully test it due to issues with my Vagrant environment (old versions will still be availabe in the `0.4.X` series)


# Vagrant-Chef-Zero
[![Build Status](https://travis-ci.org/andrewgross/vagrant-chef-zero.svg)](https://travis-ci.org/andrewgross/vagrant-chef-zero)
[![Code Climate](https://codeclimate.com/github/andrewgross/vagrant-chef-zero.png)](https://codeclimate.com/github/andrewgross/vagrant-chef-zero)
[![Dependency Status](https://gemnasium.com/andrewgross/vagrant-chef-zero.png)](https://gemnasium.com/andrewgross/vagrant-chef-zero)
[![Coverage Status](https://coveralls.io/repos/andrewgross/vagrant-chef-zero/badge.png)](https://coveralls.io/r/andrewgross/vagrant-chef-zero)

This is a plugin designed to help integrate Chef-Zero into a Vagrant run, similar to Berkshelf.  Chef-Zero will be started on the host machine and populated with the specified data.  When the Vagrant machine is destroyed Chef-Zero will be killed.

Note: Only NIX systems supported at this time due to a call to `lsof` to find running Chef Zero servers.

### Installation

```bash
vagrant plugin install vagrant-chef-zero
```

### Compatibility

Currently only tested on NIX systems, though I believe most NIX only commands have been removed.

As for Vagrant providers, it has only been tested with VirtualBox. It should be possible to add support for other providers by changing certain assumptions, such as always running Chef-Zero on the host machine.

### Activation

Just set your Vagrant provisioner to `:chef_client`.  If you wish to use `:chef_client` without using `vagrant-chef-zero` just set `config.chef_zero.enabled = false` inside your Vagrantfile configuration block.

### Configuration

Inside of your Vagrant file you will have access to the following configuration options:

```ruby
config.chef_zero.nodes = "../foobar/nodes"
config.chef_zero.environments = "../foobar/environments/baz.json"
config.chef_zero.data_bags = "../foobar/data_bags"
config.chef_zero.roles = "../foobar/roles/*.json"
config.chef_zero.cookbooks = "spec/fixtures/cookbooks"
```

Alternatively, you can use `chef_repo_path` and it will attempt to intelligently find the appropriate sub directories:

```ruby
config.chef_zero.chef_repo_path = "../foobar/my_repo/"
# This implies
# config.chef_zero.nodes = "../foobar/nodes"
# config.chef_zero.environments = "../foobar/environments"
# config.chef_zero.data_bags = "../foobar/data_bags"
# config.chef_zero.roles = "../foobar/roles"
# config.chef_zero.cookbooks = "../foobar/coobooks"

# Failure to find any of these is ok, it will just be ignored.
```


As Vagrant is booting up, `vagrant-chef-zero` will search each specified location for files to upload to Chef-Zero.  The upload will be done via Ridley APIs.

Check out the included [Vagrantfile](https://github.com/andrewgross/vagrant-chef-zero/blob/master/Vagrantfile) for example usage.

### Cookbooks

These are uploaded via the `Ridley` gem.  It is the same backend that `Berkshelf` uses, though I am sure my usage is not as complete.  It expects a path to a `cookbooks/` directory, or an array of paths to individual cookbooks.  If you omit this field, you can have `Berkshelf` upload cookbooks as usual (It will find the Chef-Zero URL automatically).

### JSON vs `.rb`

Currently only JSON files are supported as we do not have the Chef libraries to serialize `.rb` files.

### Knife Configuration

When Chef-Zero starts, it will write out `zero-knife.rb` to your current directory.  This will be a valid Knife configuration file with the following fields

```ruby
chef_server_url "foo:bar"
node_name "baz"
client_key "/path/to/tmp/key.pem"
```

If you wish to manipulate the Chef Zero server manually, you can pass this config file to Knife with `-c .zero-knife.rb`

### Lingering Chef-Zero Servers

If for some reason you are unable to have Vagrant destroy the Chef-Zero server, you can find the PID it by running `lsof -i tcp:#{port}` where `port` is 4000 by default.

## Chef Server Configuration

### Authentication

None! `vagrant-chef-zero` performs some ruby black magic to generate a fake RSA key and patch it in to the `chef-client` configuration.  You should not need to worry about providing `validation_key_path`.

### URL

You don't need to specify one! If no url is specified, `Vagrant-Chef-Zero` will find your local IPv4 address and bind to it, on port `4000`.  If you specify a Chef Server url, `Vagrant-Chef-Zero` will try to parse it and bind appropriately.

### Validation Client Name

Not required.  As `Chef-Zero` does no authentication we can fake this.  If it is left unspecified we will use a default value of `dummy-validator`.

# Contributors

* Tom Duffield (@tduffield)
* Ben Dean (@b-dean)
* Jesse Nelson (@spheromak)
* Mark Cornick (@markcornick)
* Jesse Adams (@jesseadams)
* Andrew Havens (@andrewhavens)
* Bao Nguyen (@sysbot)
