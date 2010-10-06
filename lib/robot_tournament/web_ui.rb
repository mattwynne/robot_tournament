require 'rubygems'
require 'sinatra'
require 'robot_tournament/player_upload'
require 'robot_tournament/web_ui/player_upload_handler'
[:home, :game, :help, :player, :round].each do |page_name|
  require "robot_tournament/web_ui/#{page_name}_page"
end

set :raise_errors, true if ENV['RACK_ENV'] == 'cucumber'
set :show_exceptions, false

error do
  env['sinatra.error'].message + "\n"
end

post '/players' do
  handler = PlayerUploadHandler.new(request.env["rack.input"].read)
  handler.process
end

get '/players/:name' do |player_name|
  PlayerPage.new(player_name).render
end

get '/rounds/:number' do |round_number|
  RoundPage.new(round_number.to_i).render
end

get '/' do
  HomePage.new(request.env).render
end

get '/game' do
  GamePage.new.render
end

get '/help' do
  HelpPage.new(request.env).render
end

get '/secs' do
  secs = Tournament.current.seconds_until_next_round
  if secs
    if params.key?("pure")
      secs.to_s
    else
      ChronicDuration.output(secs, :format => :long)
    end
  else
    ''
  end
end