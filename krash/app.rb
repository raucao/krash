module Krash
  class App < Sinatra::Base
    
    post "/exceptions/:access_key" do
      # TODO: move this in a before block?
      halt(401, "go away!") if params[:access_key] != Krash.config.access_key.to_s
      
      body = Nokogiri::XML(request.body)
      
      api_key = body.xpath("/notice/api-key").first.content
      exception = {
        :class => body.xpath("/notice/error/class").collect(&:content).join(","),
        :message => body.xpath("/notice/error/message").collect(&:content).join(","),
        :backtrace => body.xpath("/notice/error/backtrace").to_s,
        :request => body.xpath("/notice/request").to_s,
        :environemt => body.xpath("/notice/server-environment").to_s
      }
      
      # TODO: would be cool to do this asynchronous
      Krash.notify :api_key => api_key, :exception => exception, :raw => request.body
      
      # whatever happens we currently just say everything is great. ;)
      201
    end

  end

end