require 'vagrant/errors'

module VagrantPlugins
  module ChefZero
    class VagrantWrapperError < ::Vagrant::Errors::VagrantError

    # Stolen from Vagrant-Berkshelf
    attr_reader :original

    def initialize(original)
      @original = original
    end

    def to_s
      "#{original.to_s}"
    end

    private

      def method_missing(fun, *args, &block)
        original.send(fun, *args, &block)
      end

    end
  end
end