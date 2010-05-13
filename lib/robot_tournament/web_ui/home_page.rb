require 'mustache'
class HomePage < Mustache
  self.template_path = File.dirname(__FILE__)
  
  def initialize(players)
    @players = players
  end
  
  def players
    @players
  end
  
  def tournament
    TournamentStore.new.current
  end
end