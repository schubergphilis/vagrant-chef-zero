## 0.2.5

* Fix bug where the PID of the Chef-Zero server could not be found due to inconsistencies in the process name across operating systems.  Fixes [#11](https://github.com/andrewgross/vagrant-chef-zero/issues/11)

## 0.2.4

* Fix bug where `chef-zero` binary could not be found in RVM environments.  `vagrant-chef-zero` will now search the GEM_PATH for 'vagrant' and extrapolate to `bin/chef-zero` accordingly. Fixes [#8](https://github.com/andrewgross/vagrant-chef-zero/pull/8)

## 0.2.3

* Initial Beta Release with support for *NIX variants

