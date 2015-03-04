require 'bundler/setup'
require 'bundler/gem_tasks'

# Immediately sync all stdout so that tools like buildbot can
# immediately load in the output.
$stdout.sync = true
$stderr.sync = true

# Change to the directory of this file.
Dir.chdir(File.expand_path("../", __FILE__))

if (Rake.application.top_level_tasks == ["build"] or
    Rake.application.top_level_tasks.include?("install"))
  module Bundler
    class GemHelper
      def build_gem
        file_name = nil
        sh("USE_GIT_VERSION=1 gem build -V '#{spec_path}'") { |out, code|
          file_name = File.basename(built_gem_path)
          FileUtils.mkdir_p(File.join(base, 'pkg'))
          FileUtils.mv(built_gem_path, 'pkg')
          Bundler.ui.confirm "#{name} #{version} built to pkg/#{file_name}."
        }
        File.join(base, 'pkg', file_name)
      end
    end
  end
end

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
  FileUtils.rm_rf 'zero-knife.rb'
end
