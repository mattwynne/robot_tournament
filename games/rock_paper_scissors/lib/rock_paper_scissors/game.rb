require 'move'
class Game
  def initialize(players)
    @players = players
  end
  
  def play(reporter)
    players = [@players.first, @players.other(@players.first)]
    moves = players.map do |player| 
      Move.new(player, reporter).execute
    end

    if moves[0] == moves[1]
      reporter.draw
      return
    end
    
    sorted_moves = moves.sort.reverse
    winner = sorted_moves.first.player
    reporter.winner(winner)
  end
  
  private
  
  def move(player, reporter)
    begin
      result = player.move
    rescue FailedToMoveError => e
      reporter.move(player.name, e.message)
      reporter.fail(player.name)
      return nil
    end
    reporter.move(player.name, result)
    result
  end
end