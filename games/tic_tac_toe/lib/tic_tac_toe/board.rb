class Board
  class AlreadyOccupiedError < StandardError; end
  
  def initialize(observer)
    @observer = observer
    @grid = Array.new(9) { '-' }
  end
  
  def state
    @grid.join
  end
  
  def loser!(symbol, reason)
    @loser = symbol
    @observer.foul(symbol, reason)
    report_any_result
  end

  def move!(move, symbol)
    if illegal?(move)
      loser!(symbol, "attempted to play an illegal move")
      return
    end
    
    move = move.to_i
    
    if already_occupied?(move)
      loser!(symbol, "attempted to play on an already-taken space")
      return
    end
    
    @grid[move] = symbol
    report_any_result
  end
  
  def done?
    winner || full?
  end
  
  private
  
  def illegal?(move)
    return true unless integer?(move)
    return true if move.to_i > @grid.length
  end
  
  def integer?(move)
    Integer(move)
    return true
  rescue ArgumentError
    return false
  end
  
  def report_any_result
    return unless done?
    if winner
      @observer.winner(winner, state)
    else
      @observer.draw(state)
    end
  end
  
  def already_occupied?(move)
    @grid[move] != '-'
  end
  
  def winner
    return opposide_of(@loser) if @loser
    possible_lines.each do |line|
      content = line.map { |index| @grid[index] }
      next if content.any? { |cell| cell == '-' }
      if content.uniq.length == 1
        return content.uniq.first
      end
    end
    nil
  end
  
  def full?
    !@grid.any? { |cell| cell == '-' }
  end
  
  def possible_lines
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
  
  def opposide_of(symbol)
    return 'x' if symbol == 'o'
    'o'
  end
end