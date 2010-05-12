class StdoutReporter
  def player(name)
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