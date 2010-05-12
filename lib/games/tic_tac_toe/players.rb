require 'player'

class Players
  def initialize(paths, reporter)
    @players = paths.zip(['o', 'x']).map do |path, symbol| 
      reporter.player(path, symbol)
      Player.new(path, symbol)
    end
  end
  
  def first
    @players.first
  end
  
  def other(player)
    @players.find{ |p| p != player }
  end
end
