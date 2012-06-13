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

  def state(symbol)
    "You are player #{symbol}\n" + @map.state
  end

  def loser!(move, symbol, reason)
    @loser = symbol
    @observer.move(move, symbol)
    @observer.foul(symbol, reason)
    report_any_result(symbol)
  end

  def move!(move, symbol)
    begin
      @map.move(symbol, move)
      @observer.move(move, symbol)
      report_any_result(symbol)
    rescue Map::PlayerCollision
      loser!(move, symbol, "attempted to step on another player")
      return
    end
  end

  def done?
    !winner_symbol.nil? || @loser
  end

  private

  def report_any_result(symbol)
    return unless done?
    if winner
      @observer.winner(winner, state(symbol))
    end
  end

  def winner
    player = @players[winner_symbol]
    return player.name if player
    nil
  end

  def winner_symbol
    @map.winner
  end
end
