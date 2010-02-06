require 'builder'

# THIS CLASS IS RATHER HACKISH.... AND NEEDS SOME REFACTORING ;) 
class CodebaseProject
  
  class Ticket
    attr_accessor :kind, :attributes
    
    def initialize(attributes)
      self.kind = attributes.delete(:kind) || "ticket"
      self.attributes = attributes
    end
    
    def to_xml
      builder = Builder::XmlMarkup.new
      builder.tag!(self.kind) do |ticket|
        attributes.each do |key,value|
          ticket.tag!(key, value) unless value.nil?
        end
      end
      
    end
  end
  
  include HTTParty
  base_uri 'http://railslove.codebasehq.com'
  headers 'Accept' => 'application/xml'
  headers 'Content-type' => 'application/xml'
  
  def initialize(options)
    @auth = {:username => options[:user], :password => options[:api_key]}
    @project = options[:project]
  end

  def create_ticket(args={})
    content = args.delete(:content)
    
    ticket = self.class.post url_for("/tickets"), :body => Ticket.new(args.merge(:kind => "ticket")).to_xml, :basic_auth => @auth
    
    add_note_to_ticket(ticket["ticket"]["ticket_id"], content) if content
  end
  
  def add_note_to_ticket(ticket_id, content)
    # TODO: codebase api seems to be strange here... they respond with an exception?! --- hack: just ignore it
    begin
      self.class.post url_for("/tickets/#{ticket_id}/notes"), :body => Ticket.new(:content => content, :kind => "ticket-note").to_xml, :basic_auth => @auth 
    rescue
    end
  end
  
  def tickets(args={})
    self.class.get(url_for("/tickets"), :query => args, :basic_auth => @auth)["tickets"]
  end
  
  protected
    def url_for(path)
      "/#{@project}#{path}"
    end
end

module Krash
  module Notifiers
    
    class Codebase
      attr_accessor :config
      
      def initialize(config)
        @config = config
      end
      
      def notify(args)
        content = ""
        args[:exception].each do |key,value|
          content << key.to_s
          content << "\n"
          content << "--------------"
          content << "\n\n"
          value.each do |line|
            content << "    #{line}"
          end
          content << "\n\n\n"
        end
        
        ticket = {
          :summary => args[:exception][:message ],
          :content => content,
          :"ticket-type" => "bug",
          :"priority-id" => @config.priority_id,
          :"status-id" => @config.status_id
        }
        
        CodebaseProject.new(:user => @config.user, :api_key => @config.api_key, :project => args[:api_key]).create_ticket(ticket)
      end
      
    end
    
  end
end