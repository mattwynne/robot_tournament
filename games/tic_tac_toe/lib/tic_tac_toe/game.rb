require 'board'

class Game
  # 012
  # 345
  # 678

  def initialize(players)
    @players = players
    @current_player = @players.first
  end
  
  def play(reporter)
    board = Board.new(reporter, @players)
    until board.done?
      reporter.state(board.state)
      move = @current_player.move(board, reporter)
      switch_players!
    end
  end
  
  private
  
  def player
    @current_player
  end
  
  def switch_players!
    @current_player = @players.other(@current_player)
  end
end