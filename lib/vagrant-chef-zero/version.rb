module VagrantPlugins
  module ChefZero
    VERSION = "2.0.0"
    NAME = "vagrant-chef-zero"

    def self.describe(opts={})
      query = 'git describe --tags --match="v*"'
      args = opts.map do |k, v|
        "--#{k.to_s}=#{v.to_s}"
      end.join(" ")
      `#{query} #{args}`
    end

    def self.git_version(options = {})
      version = self.describe(options).chomp
      version.gsub!('-', '.')
      version = version[1..-1] if version.start_with?("v")
    end

    def self.get_version
      if Gem.loaded_specs.key?(NAME)
        # installed version
        version = Gem.loaded_specs[NAME].version
      elsif ENV['USE_GIT_VERSION'] == "1"
        version = self.git_version()
        if Gem::Version.new(version) < Gem::Version.new(VERSION)
          version = VERSION
        end
      else
        version = VERSION
      end
      version
    end
  end
end
