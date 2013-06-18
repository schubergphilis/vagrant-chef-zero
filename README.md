# Vagrant-Chef-Zero

This is a plugin designed to help integrate Chef-Zero into a Vagrant run, similar to Berkshelf.  Chef-Zero will be started on the host machine and populated with the specified data.  When the Vagrant machine is destroyed Chef-Zero will be killed.

Note: Only NIX systems supported at this time due to a call to `lsof` to find running Chef Zero servers.

### Installation

```bash
vagrant plugin install vagrant-chef-zero
```

### Compatability

Currently only NIX systems supported at this time due to a call to `lsof` to find running Chef Zero servers.

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

As Vagrant is booting up, `vagrant-chef-zero` will search each specified location for files to upload to Chef-Zero.  The upload will be done via Ridley APIs.

### Cookbooks

These are uploaded via the `Ridley` gem.  It is the same backend that `Berkshelf` uses, though I am sure my usage is not as complete.  It expects a path to a `cookbooks/` directory, or an array of paths to individual cookbooks.  If you omit this field, you can have `Berkshelf` upload cookbooks as usual (It will find the Chef-Zero URL automatically).

### JSON vs `.rb`

Currently only JSON files are supported as we do not have the Chef libraries to serialize `.rb` files.

### Lingering Chef-Zero Servers

If for some reason you are unable to have Vagrant destroy the Chef-Zero server, you can find the PID it by running `lsof -i tcp:#{port}` where `port` is 4000 by default.

## Chef Server Configuration

### Authentication

None! `vagrant-chef-zero` performs some ruby black magic to generate a fake RSA key and patch it in to the `chef-client` configuration.  You should not need to worry about providing `validation_key_path`.

### URL

You don't need to specify one! If no url is specified, `Vagrant-Chef-Zero` will find your local IPv4 address and bind to it, on port `4000`.  If you specify a Chef Server url, `Vagrant-Chef-Zero` will try to parse it and bind appropriately.

### Validation Client Name

Not required.  As `Chef-Zero` does no authentication we can fake this.  If it is left unspecified we will use a default value of `dummy-validator`.

