require 'rubygems'
require 'sinatra'
require 'player_upload'

error do
  "ERROR: #{env['sinatra.error']}\n#{env['sinatra.error'].backtrace.join("\n")}"
end
  
post '/players' do
  raw = request.env["rack.input"].read
  upload = PlayerUpload.new(raw)
  upload.process!
  upload.response
end

get '/' do
  PlayerStore.new.players.map{ |p| p.name }.to_s
end