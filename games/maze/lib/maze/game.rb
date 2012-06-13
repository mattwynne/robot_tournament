require 'board'

class Game
  MAP_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'maps'))

  def initialize(players, opts)
    @players = players
    @current_player = @players.first
    Player.max_move_secs = opts[:timeout] if opts[:timeout]

    @map = Map.load(select_map(opts[:map]))
    @maxmoves = opts[:maxmoves]
  end

  def play(reporter)
    board = Board.new(reporter, @players, @map, @maxmoves)
    until board.done?
      reporter.state(board.state(@current_player.symbol))
      move = @current_player.move(board, reporter)
      switch_players!
    end
    if (board.max_moves_reached?)
      reporter.draw(board.state(@current_player.symbol))
    end
  end

  private

  def player
    @current_player
  end

  def switch_players!
    @current_player = @players.other(@current_player)
  end

  def select_map(preselected = nil)
    map = available_maps.detect { |m| File.basename(m) == preselected }
    map || available_maps[rand(available_maps.size)]
  end

  def available_maps
    @available_maps ||= Dir[MAP_PATH + '/*']
  end
end
