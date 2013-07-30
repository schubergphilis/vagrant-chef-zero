## 0.3.0

* Add support for `chef_repo_path`, graciously provided by @tduffield via pull request, as I was taking too long.

## 0.2.10

* Fix bug where we could find multiple gem paths with 'vagrant' in them, causing the construction of an erroneous Chef Zero binary path.  Fixes [#10](https://github.com/andrewgross/vagrant-chef-zero/issues/10)

## 0.2.9

* Fix Berkshelf support by being selfish and putting Chef Zero before Berkshelf (and anything else) in the load order for `up`, `provision` and `reload`


## 0.2.8

* Fix Berkshelf support by monkeypatching `client_key` in all Berkshelf Objects


## 0.2.7

* Re-add ActiveSupport dependency because otherwise the plugin cannot install correctly in Vagrant.


## 0.2.6

* Remove unused ActiveSupport dependency.
* Add MIT License


## 0.2.5

* Fix bug where the PID of the Chef-Zero server could not be found due to inconsistencies in the process name across operating systems.  Fixes [#11](https://github.com/andrewgross/vagrant-chef-zero/issues/11)

## 0.2.4

* Fix bug where `chef-zero` binary could not be found in RVM environments.  `vagrant-chef-zero` will now search the GEM_PATH for 'vagrant' and extrapolate to `bin/chef-zero` accordingly. Fixes [#8](https://github.com/andrewgross/vagrant-chef-zero/pull/8)

## 0.2.3

* Initial Beta Release with support for *NIX variants

