require 'mustache'
require 'robot_tournament/web_ui/tournament_presenter'

class RoundPage < Mustache
  self.template_path = File.dirname(__FILE__)
  
  def initialize(round_number)
    @round = round(round_number)
  end
  
  def name
    @round.name
  end
  
  def players
    @round.players
  end
  
  def results
    @round.results
  end
  
private

  def round(round_number)
    tournament.finished_rounds.find do |round|
      round.number == round_number
    end
  end
  
  def tournament
    TournamentPresenter.new(Tournament.current)
  end
end