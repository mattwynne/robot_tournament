require 'rubygems'
require 'sinatra'
require 'player_upload'
require 'web_ui/player_upload_handler'
require 'web_ui/home_page'

set :raise_errors, true

post '/players' do
  handler = PlayerUploadHandler.new(request.env["rack.input"].read)
  handler.process
end

get '/' do
  players = PlayerStore.new.players
  HomePage.new(players).render
end