class Board
  def initialize
    @grid = Array.new(9) { '-' }
  end
  
  def state
    @grid.join
  end
  
  def update(move, player_name)
    unless (existing_move = @grid[move]) == '-'
      raise("Player #{player_name} loses for trying to go on a square (#{move}) that's already occupied by #{existing_move}")
    end
    @grid[move] = player_name
  end
  
  def full?
    !@grid.any? { |cell| cell == '-' }
  end
  
  def winner
    lines.each do |line|
      content = line.map { |index| @grid[index] }
      next if content.any? { |cell| cell == '-' }
      if content.uniq.length == 1
        return content.uniq.first
      end
    end
    nil
  end
  
  def lines
    [
      [0,1,2],
      [3,4,5],
      [6,7,8],
      [0,3,6],
      [1,4,7],
      [2,5,8],
      [0,4,8],
      [2,4,6]
    ]
  end
end