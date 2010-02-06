require "spec_helper"
require "krash/notifiers/sms"

describe Krash::Notifiers::Sms do
  
  before do
    @default_config = Krash::Configuration.new do
      number 123
      user "user"
      password "passwd"
      api_key "key"
      only /.*/
    end
    @notifier = Krash::Notifiers::Sms.new(@default_config)
  end
  
  describe "Notification" do
    it "should not notify only if the exception message matches not a certain pattern" do
      @notifier.should_not_receive(:clickatell)
      @notifier.config.only = /\d/
      @notifier.notify(:exception => {:message => "not number"} ).should == false
    end
    
    it "should notify if the exception message matches a certain pattern" do
      clickatell = mock(:clickatell)
      clickatell.should_receive(:send).with(@default_config.number,"123")
      
      @notifier.should_receive(:clickatell).and_return(clickatell)
      @notifier.config.only = /\d/
      @notifier.notify(:exception => {:message => "123"} )
    end
    
    
  end

end
