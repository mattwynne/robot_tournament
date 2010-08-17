require 'mustache'
require 'robot_tournament/web_ui/tournament_presenter'

class HomePage < Mustache
  self.template_path = File.dirname(__FILE__)
  
  def initialize(env)
    @env = env
  end
  
  def tournament
    TournamentPresenter.new(Tournament.current)
  end
  
  def game
    Tournament.current.game_name
  end
end