## 0.2.3

* Initial Beta Release with support for *NIX variants

## 0.2.4

* Fix bug where `chef-zero` binary could not be found in RVM environments.  `vagrant-chef-zero` will now search the GEM_PATH for 'vagrant' and extrapolate to `bin/chef-zero` accordingly. Fixes [#8](https://github.com/andrewgross/vagrant-chef-zero/pull/8)