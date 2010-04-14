require 'rubygems'
require 'sinatra'
require 'player_upload'
require 'home_page'

error do
  "ERROR: #{env['sinatra.error']}\n#{env['sinatra.error'].backtrace.join("\n")}"
end
  
post '/players' do
  handler = PlayerUploadHandler.new(request.env["rack.input"].read)
  handler.process
end

get '/' do
  players = PlayerStore.new.players
  HomePage.new(players).render
end