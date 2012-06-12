require 'player'

class Players
  def initialize(paths, reporter)
    @players = paths.zip(['0', 'x']).map do |path, symbol| 
      Player.new(path, symbol)
    end
    
    @players.each { |player| player.report_to(reporter) }
  end
  
  def [](symbol)
    @players.find{ |p| p.symbol == symbol}
  end
  
  def first
    @players.first
  end
  
  def other(player)
    @players.find{ |p| p != player }
  end
end
