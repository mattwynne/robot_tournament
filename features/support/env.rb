ENV['RACK_ENV'] ||= 'cucumber'

require File.dirname(__FILE__) + '/../../lib/robot_tournament'
require 'robot_tournament/web_ui'
require 'rack/test'
   
module SinatraWorld
  def app
    Sinatra::Application
  end
end

World(SinatraWorld)
World(Rack::Test::Methods)

Before do
  PlayerStore.new.clear
end