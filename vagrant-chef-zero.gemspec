$:.unshift File.expand_path("../lib", __FILE__)
require "vagrant-chef-zero/version"

Gem::Specification.new do |s|
  s.name          = "vagrant-chef-zero"
  s.version       = VagrantPlugins::ChefZero::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = "Andrew Gross"
  s.email         = "andrew.w.gross@gmail.com"
  s.homepage      = "http://github.com/andrewgross/vagrant-chef-zero"
  s.summary       = "Enables Vagrant to interact with Chef Zero."
  s.description   = "Enables Vagrant to interact with Chef Zero"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "vagrant-chef-zero"

  s.add_dependency "chef-zero", "~> 1.3"
  s.add_dependency "ridley", ">= 1.0.0"


  # Stolen from Vagrant Berkshelf because Ruby hates dependency resolution
  # activesupport 3.2.13 contains an incompatible hard lock on i18n (= 0.6.1)
  s.add_dependency 'activesupport', '>= 3.2.0', '< 3.2.13'

  # Explicit locks to ensure we activate the proper gem versions for Vagrant
  s.add_dependency 'i18n', '~> 0.6.0'
  s.add_dependency 'net-ssh', '~> 2.6.6'
  s.add_dependency 'net-scp', '~> 1.1.0'

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
  s.add_development_dependency "debugger"

  # The following block taken from @mitchellh 's vagrant-aws code

  # The following block of code determines the files that should be included
  # in the gem. It does this by reading all the files in the directory where
  # this gemspec is, and parsing out the ignored files from the gitignore.
  # Note that the entire gitignore(5) syntax is not supported, specifically
  # the "!" syntax, but it should mostly work correctly.
  root_path      = File.dirname(__FILE__)
  all_files      = Dir.chdir(root_path) { Dir.glob("**/{*,.*}") }
  all_files.reject! { |file| [".", ".."].include?(File.basename(file)) }
  gitignore_path = File.join(root_path, ".gitignore")
  gitignore      = File.readlines(gitignore_path)
  gitignore.map!    { |line| line.chomp.strip }
  gitignore.reject! { |line| line.empty? || line =~ /^(#|!)/ }

  unignored_files = all_files.reject do |file|
    # Ignore any directories, the gemspec only cares about files
    next true if File.directory?(file)

    # Ignore any paths that match anything in the gitignore. We do
    # two tests here:
    #
    #   - First, test to see if the entire path matches the gitignore.
    #   - Second, match if the basename does, this makes it so that things
    #     like '.DS_Store' will match sub-directories too (same behavior
    #     as git).
    #
    gitignore.any? do |ignore|
      File.fnmatch(ignore, file, File::FNM_PATHNAME) ||
        File.fnmatch(ignore, File.basename(file), File::FNM_PATHNAME)
    end
  end

  s.files         = unignored_files
  s.executables   = unignored_files.map { |f| f[/^bin\/(.*)/, 1] }.compact
  s.require_path  = 'lib'
end
