module VagrantPlugins
  module ChefZero
    class Env
      attr_accessor :ui

      def initialize
        @ui = ::Vagrant::UI::Colored.new.scope('Chef Zero')
      end
    end
  end
end