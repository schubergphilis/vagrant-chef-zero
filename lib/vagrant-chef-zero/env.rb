module VagrantPlugins
  module ChefZero
    # @author Jamie Winsor <reset@riotgames.com>
    #
    # Environment data to build up and persist through the middleware chain
    class Env
      # @return [Vagrant::UI::Colored]
      attr_accessor :ui

      # @return [String]
      attr_accessor :port

      # @return [String]
      attr_accessor :pid

      # @return [String]
      attr_accessor :host

      def initialize
        if Gem::Version.new(::Vagrant::VERSION) >= Gem::Version.new("1.2")
          @ui     = ::Vagrant::UI::Colored.new.scope('ChefZero')
        else
          @ui     = ::Vagrant::UI::Colored.new('ChefZero')
        end
        @port = VagrantPlugins::ChefZero::Config.port
        @pid = nil
        @host = VagrantPlugins::ChefZero::Config.host
      end
    end
  end
end