require 'player'

class Players
  def initialize(paths, reporter)
    @players = paths.zip(['o', 'x']).map do |path, symbol| 
      player = Player.new(path, symbol)
    end
    
    @players.each { |player| player.report_to(reporter) }
  end
  
  def first
    @players.first
  end
  
  def other(player)
    @players.find{ |p| p != player }
  end
end