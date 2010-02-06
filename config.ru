require "krash"

require "krash/notifiers/codebase"
require "krash/notifiers/sms"

Krash.configure do

  set :access_key, "018e5282be7b34beecd8"
  
  use Krash::Notifiers::Codebase do 
  
    priority_id 20658
    status_id 28658
    user "user"
    api_key "api_key"
    
  end
  
  #use Krash::Notifiers::Sms do 
  #  
  #  user "user"
  #  password "password"
  #  api_key "api_key"
  #  only /.*/
  #  number "+4917622747893"
  #  
  #end

end

run Krash::App