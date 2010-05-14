class StdoutReporter
  def player(name)
  end
  
  def fail(name, message)
    puts "Player '#{name}' has #{message} and has forfeited the game."
  end
  
  def draw
    puts "Result: draw"
  end
  
  def winner(name)
    puts "Result: #{name} wins"
  end
  
  def move(name, move)
    puts "#{name}: #{move}"
  end
  
  def invalid(name)
    puts "Player '#{name}' has made an invalid move and has forfeited the game."
  end
end