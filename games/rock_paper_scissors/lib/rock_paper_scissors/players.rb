require 'player'

class Players
  def initialize(paths, reporter)
    @players = paths.map { |path| Player.new(path) }
    @players.each { |player| player.report_to(reporter) }
  end
  
  def first
    @players.first
  end
  
  def other(player)
    @players.find{ |p| p != player }
  end
end
