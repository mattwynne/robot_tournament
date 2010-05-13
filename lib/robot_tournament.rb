$:.push File.dirname(__FILE__)
require 'robot_tournament/player_store'
require 'robot_tournament/player_upload'
require 'robot_tournament/tournament_store'
require 'robot_tournament/current_tournament'

module RobotTournament
  attr_accessor :base_dir
  extend self
end

RobotTournament.base_dir = File.expand_path(File.dirname(__FILE__) + '/../')