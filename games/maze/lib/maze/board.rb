class Board
  class AlreadyOccupiedError < StandardError; end

  def default_map
     blueprint = "***********\n" +
                 "*......__.F\n" +
                 "*...***...*\n" +
                 "*...***...*\n" +
                 "***********"

    Map.new(blueprint, [1,1], [1,3])
  end

  def initialize(observer, players, map)
    @observer = observer
    @players = players
    @map = map || default_map
  end

  def state
    @map.state
  end

  def loser!(move, symbol, reason)
    @loser = symbol
    @observer.move(move, symbol)
    @observer.foul(symbol, reason)
    report_any_result
  end

  def move!(move, symbol)
    begin
      @map.move(symbol, move)
      @observer.move(move, symbol)
      report_any_result
    rescue Map::PlayerCollision
      loser!(move, symbol, "attempted to step on another player")
      return
    end
  end

  def done?
    !winner_symbol.nil?
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
    player = @players[winner_symbol]
    return player.name if player
    nil
  end

  def winner_symbol
    @map.winner
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
    return 'x' if symbol == '0'
    '0'
  end
end
