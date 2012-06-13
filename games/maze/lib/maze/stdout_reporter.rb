class StdoutReporter
  def player(name, symbol)
    puts "player #{symbol}: '#{name}'"
  end
  
  def foul(symbol, message)
    puts "FOUL! player #{symbol} has #{message} and loses by default"
  end
  
  def winner(name, board_state)
    state(board_state)
    puts "Result: #{name} wins"
  end
  
  def draw(board_state)
    state(board_state)
    puts "Result: draw"
  end
  
  def move(move, symbol)
    puts "#{symbol} move: #{move}"
  end
  
  def state(board_state)
    puts "#{board_state}"
  end
end
