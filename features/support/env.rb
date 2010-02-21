require File.dirname(__FILE__) + '/../../app'
require 'rack/test'

module SinatraWorld
  def app
    Sinatra::Application
  end
end

World(SinatraWorld)
World(Rack::Test::Methods)