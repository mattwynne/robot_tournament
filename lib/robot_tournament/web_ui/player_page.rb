require 'mustache'
require 'robot_tournament/web_ui/tournament_presenter'

class PlayerPage < Mustache
  self.template_path = File.dirname(__FILE__)
  
  class FilteredRound
    def initialize(round, player_name)
      @round, @player_name = round, player_name
    end
    
    def results
      @round.results_for_player(@player_name)
    end
    
    def name
      @round.name
    end
  end
  
  def initialize(player_name)
    @player_name = player_name
    @tournament = TournamentPresenter.new(Tournament.current)
  end
  
  def rounds
    @tournament.finished_rounds.map do |round|
      FilteredRound.new(round, @player_name)
    end
  end
  
  def name
    @player_name
  end
end