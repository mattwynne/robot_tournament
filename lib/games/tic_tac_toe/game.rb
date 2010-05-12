require 'board'

class Game
  # 012
  # 345
  # 678

  def initialize(players)
    @players = players
    @current_player = @players.first
    @board = Board.new
  end
  
  def play(reporter)
    reporter.state(@board.state)
    until winner? or @board.full?
      @current_player.move(@board, reporter)
      switch_players!
    end
    reporter.result(result)
  end
  
  private
  
  def switch_players!
    @current_player = @players.other(@current_player)
  end
  
  def result
    winner if winner?
    "draw"
  end
  
  def winner?
    !!winner
  end
  
  def winner
    @board.winner
  end
end