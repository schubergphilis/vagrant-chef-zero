## License Change

* April 15, 2015 license changed to Apache License v2.0 to allow the new maintainer to work on this project during working hours.

## 0.7.1

* Allow passing in mixed cookbook directories and absolute paths.  Thanks @jesseadams
* Some minor development fixes regarding ruby

## 0.7.0

* Allow using the latest version of `Chef-Zero`
* Compatability fix to work with Vagrant 1.5, thanks to @andrewhavens and @sysbot for fixes.

NOTE: Attempting to work on migrating to `chef-api` instead of `ridley` to help with dependency issues.

NOTE: May be an issue if we do not constrain `ridley` to an upper bound so that `vagrant` doesn't grab a broken version. Candidate version `'ridley', '~> 1.2.1'`.


## 0.6.0

Remove some dependency cruft, add better cookbook searching.

* Remove custom dependencies for `i18n`, `json`, `net-ssh`, `net-scp` and `activesupport`.  Still depend on Chef, but no longer force specific gem versions. Seems to install properly on Vagrant 1.4.

* Add better cookbook searching algorithm

## 0.5.2

Update `net-ssh` dependency to work with the newest version of Vagrant 1.4.  Thanks to @paulczar

* Search for the Chef-Zero gem inside of Vagrant first, then fall back to searching other gem paths.  Mostly a fix to make testing easier.

## 0.5.1

Minor bugfixes (hopefully) to fix installation behavior and berkshelf issues.

* Back out change adding ||= to berkshelf key replacement as it was causing issues.

* Attempt to match the Chef dependency order more closely to avoid ruby gem installation issues

## 0.5.0

NOTE: This version is in beta status as I have not had time to fully test it due to issues with my Vagrant environment (old versions will still be availabe in the `0.4.X` series)

* Add support for `.rb` files by using the Chef Gem, thanks to @mattray for the PR.

## 0.4.2

* Keep existing Berkshelf client key if one is already defined. Thanks to [Greg Symons](https://github.com/gregsymons) for the PR.

## 0.4.1

* This is a belated changelog, as I apparently did not push one with this version in the past

* Fix issues with Chef-Zero and Vagrant reload action.  See commit 2a2c6673d303f0768aec2909f19713a9f1ebb14e for more details


## 0.4.0

* Always write out a simple Knife configuration file to `.zero-knife.rb` to make it easier to use Knife with the server.

* Switch to RSpec for tests.  Thanks to @tduffield for porting the existing tests.

* Chef-Zero now uses the Chef-Zero gem to manage starting and stopping of the server.  While this may change in the future, it is the simplest solution for now.


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

