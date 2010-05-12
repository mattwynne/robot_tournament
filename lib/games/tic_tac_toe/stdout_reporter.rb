class StdoutReporter
  def player(path, symbol)
    puts "player #{symbol}: #{path}"
  end

  def result(winner)
    puts "winner: #{winner}"
  end
  
  def move(name, move)
    puts "#{name} move: #{move}"
  end
  
  def state(board_state)
    puts "board:\n#{board_state}"
  end
end