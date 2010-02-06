require "spec_helper"
require "krash/configuration"

describe Krash::Configuration do
  
  before do
    @test_configuration = {:user => "joe", :password => "123", :key => "321"}
    @default_config = {:holly => "shit"}
    @configuration = Krash::Configuration.new do
      holly "shit"
    end
  end
  
  describe "saving configuration data" do
    
    it "should accept a block to save the configuration" do
      c = Krash::Configuration.new do 
        omg "holly shit"
      end
      c.options.should == {:omg => "holly shit"}
    end
    
    it "should accept saving configuration as method call" do
      c = Krash::Configuration.new
      c.style "awesome"
      c.style.should == "awesome"
    end
    
    it "should strip = when used in a method call to save configuration data" do
      c = Krash::Configuration.new
      c.omg= "holly shit"
      c.options.should == {:omg => "holly shit"}
    end
    
    it "should allow seaving configuration like a hash" do
      c = Krash::Configuration.new
      c["omg"] = "yeah"
      c.options.should == {:omg => "yeah"}
    end
    
  end
  
  
  describe "reading configuration data" do
    
    it "should return nil as default" do
      @configuration.is_not_set.should == nil
    end
    
    it "should allow accessing the options hash directy" do
      @configuration.should respond_to("options")
      @configuration.options.should == @default_config
    end
    
    it "should allow accessing the configuration data as method call" do
      c = Krash::Configuration.new do 
        user "joe"
        password "123"
        key "321"
      end
      {:user => "joe", :password => "123", :key => "321"}.each do |key, value|
        c.send(key).should == value
      end
    end
    
    it "should allow reading configuration like a hash" do
      @configuration["holly"].should == "shit"
    end
    
  end

end
