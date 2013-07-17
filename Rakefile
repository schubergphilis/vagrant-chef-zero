require 'rake/testtask'
require 'bundler/setup'
require 'bundler/gem_tasks'

# Immediately sync all stdout so that tools like buildbot can
# immediately load in the output.
$stdout.sync = true
$stderr.sync = true

# Change to the directory of this file.
Dir.chdir(File.expand_path("../", __FILE__))

# This installs the tasks that help with gem creation and
# publishing.
#Bundler::GemHelper.install_tasks

# Default task is to run the unit tests
task :default => "test"

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

task :clean do |t|
  require 'fileutils'
  FileUtils.rm_rf 'pkg'
  system('bundle exec vagrant destroy -f')
  FileUtils.rm_rf '.vagrant'
  FileUtils.rm_rf 'coverage'
  FileUtils.rm_rf 'Gemfile.lock'
end
