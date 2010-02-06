require 'rubygems'
require 'clickatell'

module Krash
  module Notifiers
    
    class Sms
      attr_accessor :config
      
      def initialize(config)
        @config = config
      end
      
      def notify(args)
        return false unless args[:exception][:message] =~ @config.only
        clickatell.send(@config.number, args[:exception][:message])
      end
      
      def clickatell
        Clickatell::Text.new(@config.user, @config.password, @config.api_key)
      end
    end
  end
end