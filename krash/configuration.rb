module Krash
  class Configuration
    attr_accessor :options
    
    def initialize(&block)
      @options = {}
      self.instance_eval(&block) if block_given?
    end
    
    def [](key)
      self.options[key.to_sym]
    end
    
    def []=(key,value)
      self.options[key.to_sym] = value
    end
    
    def method_missing(sym, *args, &block)
      key = sym.to_s.gsub(/=$/,"").to_sym
      unless args.empty?
        @options[key] = *args
      end

      @options[key]
    end

  end
end