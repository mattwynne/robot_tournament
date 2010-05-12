class Game
  def initialize(players)
    @players = players
  end
  
  def play(reporter)
    player1 = @players.first
    player2 = @players.other(player1)

    player1_move = player1.move
    reporter.move(player1.name, player1.move)
    player2_move = player2.move
    reporter.move(player2.name, player2.move)
    
    if player1_move == player2_move
      reporter.draw
      return
    end
    
    wins = [
      ["paper",    "rock"],
      ["scissors", "paper"],
      ["rock",     "scissors"],
    ]
    
    wins.each do |winner, loser|
      if player1_move == winner and player2_move == loser
        reporter.winner(player1)
        break
      elsif player1_move == loser and player2_move == winner
        reporter.winner(player2)
        break
      end
    end
  end
end