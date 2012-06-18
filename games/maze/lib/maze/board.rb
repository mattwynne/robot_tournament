class Board
  class AlreadyOccupiedError < StandardError; end

  MAX_MOVES_EACH = 200

  def default_map
     blueprint = "***********\n" +
                 "*......__.F\n" +
                 "*...***...*\n" +
                 "*...***...*\n" +
                 "***********"

    Map.new(blueprint, [1,1], [1,3])
  end

  def initialize(observer, players, map, max_moves)
    @observer = observer
    @players = players
    @moves = 0
    @max_moves_each = max_moves || MAX_MOVES_EACH
    @map = map || default_map
  end

  def state(symbol)
    state = ["You are player #{symbol}\n", @map.state]
    state << "\nThe game has taken more than #{@max_moves_each} moves each and is therefore a draw.\n" if max_moves_reached?
    state.join
  end

  def loser!(move, symbol, reason)
    @loser = symbol
    @observer.move(move, symbol)
    @observer.foul(symbol, reason)
    report_any_result(symbol)
  end

  def move!(move, symbol)
    begin
      @moves += 1
      @map.move(symbol, move)
      @observer.move(move, symbol)
      report_any_result(symbol)
    rescue Map::PlayerCollision
      loser!(move, symbol, "attempted to step on another player")
      return
    rescue Map::WallCollision
      loser!(move, symbol, "attempted to move into the wall")
      return
    rescue Map::IllegalMove
      loser!(move, symbol, "attempted to make an illegal move")
      return
    end
  end

  def done?
    max_moves_reached? || !winner_symbol.nil?
  end

  def max_moves_reached?
    @moves >= @max_moves_each * 2
  end

  private

  def report_any_result(symbol)
    return unless done?
    if winner
      @observer.winner(winner, state(symbol))
    else
      @observer.draw(@map.state)
    end
  end

  def winner
    player = @players[winner_symbol]
    return player.name if player
    nil
  end

  def winner_symbol
    return @players.other(@players[@loser]).symbol if @loser
    @map.winner
  end
end
