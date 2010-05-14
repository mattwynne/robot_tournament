class StdoutReporter
  def player(name)
  end
  
  def fail(name, message)
    move(name, message)
    puts "Player '#{name}' has returned a non-zero exit status and has forfeited the game."
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
end