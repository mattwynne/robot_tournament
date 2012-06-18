class Map
  def self.load(path)
    loader = MapLoader.new(path)
    new(loader.blueprint, *loader.players_start)
  end

  def initialize(blueprint, player1_start, player2_start)
    @blueprint = blueprint.split("\n").map { |row| row.scan(/./) }
    @positions = { '1' => player1_start, '2' => player2_start }
  end

  def state
    state = Marshal.load(Marshal.dump(@blueprint))
    @positions.each do |symbol, position|
      state[position.last][position.first] = symbol
    end
    state.map(&:join).join("\n")
  end

  def move(player, direction)
    direction = direction.strip.upcase
    raise IllegalMove unless legal_move?(direction)
    new_position = proposed_position(player, direction)

    raise PlayerCollision if @positions.values.include?(new_position)

    if tile_at(*new_position) == '*'
      raise WallCollision
    else
      @positions[player] = new_position
    end

    return nil
  end

  def winner
    winner = @positions.detect do |symbol, position|
      tile_at(*position) == 'F'
    end

    winner && winner.first
  end

  private
  def axis(direction)
    ['S', 'N'].include?(direction) ? 1 : 0
  end

  def legal_move?(direction)
    %{N S E W}.include?(direction)
  end

  def movement(direction)
    ['N', 'W'].include?(direction) ? -1 : 1
  end

  def proposed_position(player, direction)
    new_position = @positions[player].dup
    new_position[axis(direction)] += movement(direction)

    while tile_at(*new_position) == '_'
      new_position[axis(direction)] += movement(direction)
    end

    new_position
  end

  def back_off_the_wall(position, direction)
    position[axis(direction)] -= movement(direction)
    position
  end

  def tile_at(x,y)
    @blueprint[y][x]
  end

  PlayerCollision = Class.new(StandardError)
  WallCollision = Class.new(StandardError)
  IllegalMove = Class.new(StandardError)
end
