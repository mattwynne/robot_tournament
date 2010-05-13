ENV['RACK_ENV'] ||= 'cucumber'

require File.dirname(__FILE__) + '/../../lib/robot_tournament'
require 'robot_tournament/web_ui'

require 'capybara/cucumber'
Capybara.app = Sinatra::Application

RobotTournament.base_dir = RobotTournament.base_dir + '/tmp/cucumber'

module TournamentWorld
  def tournament
    TournamentStore.new.current
  end  
end

World(TournamentWorld)

Before do
  TournamentStore.new.clear
end

After do |scenario|
  if scenario.failed?
    save_and_open_page
  end
end