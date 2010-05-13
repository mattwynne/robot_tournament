ENV['RACK_ENV'] ||= 'cucumber'

require File.dirname(__FILE__) + '/../../lib/robot_tournament'
require 'robot_tournament/web_ui'

RobotTournament.base_dir = RobotTournament.base_dir + '/tmp/cucumber'
Before do
  TournamentStore.new.clear
end

World(CurrentTournament)