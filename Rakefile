require 'bundler/setup'
require 'bundler/gem_tasks'

# Immediately sync all stdout so that tools like buildbot can
# immediately load in the output.
$stdout.sync = true
$stderr.sync = true

# Change to the directory of this file.
Dir.chdir(File.expand_path("../", __FILE__))

# Make testing the default task
task :default => "rspec_test"

task :rspec_test do |t|
  test_output = %x[ bundle exec rspec spec ]
  puts test_output
  coverage = %x[ cat ./coverage/.last_run.json | grep covered | awk '{print $2}' ]
  puts "Coverage: #{coverage}"
end

task :clean do |t|
  require 'fileutils'
  FileUtils.rm_rf 'pkg'
  system('bundle exec vagrant destroy -f')
  FileUtils.rm_rf '.vagrant'
  FileUtils.rm_rf 'coverage'
  FileUtils.rm_rf 'Gemfile.lock'
end
