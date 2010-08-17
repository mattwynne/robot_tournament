require 'mustache'

class HelpPage < Mustache
  self.template_path = File.dirname(__FILE__)
  
  def initialize(env)
    @env = env
  end
  
  def upload_path
    "#{@env["rack.url_scheme"]}://#{@env["HTTP_HOST"]}/players"
  end
end