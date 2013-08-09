module VagrantPlugins
  module ChefZero
    # @author Jamie Winsor <reset@riotgames.com>
    #
    # Environment data to build up and persist through the middleware chain
    class Env
      # @return [Vagrant::UI::Colored]
      attr_accessor :ui
      # @return [ChefZero::Server]
      attr_accessor :server

      def initialize
        @ui = ::Vagrant::UI::Colored.new.scope('Chef Zero')
      end
    end
  end
end
