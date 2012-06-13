class Map
  def self.load(path)
  end

  def initialize(blueprint, player1_start, player2_start)
    @blueprint = blueprint.split("\n").map { |row| row.scan(/./) }
    @positions = { '1' => player1_start, '2' => player2_start }
  end

  def state
    state = @blueprint.dup
    state[@positions['1'].first][@positions['1'].last] = '1'
    state[@positions['2'].first][@positions['2'].last] = '2'
    state.map(&:join).join("\n")
  end

  def move(player, direction)
    new_position = proposed_position(player, direction)

    raise PlayerCollision if @positions.values.include?(new_position)
    @positions[player] = new_position if tile_at(*new_position) == '.'

    return nil
  end

  private
  def axis(direction)
    ['E', 'W'].include?(direction) ? 1 : 0
  end

  def movement(direction)
    ['N', 'W'].include?(direction) ? -1 : 1
  end

  def proposed_position(player, direction)
    new_position = @positions[player].dup
    new_position[axis(direction)] += movement(direction)
    new_position
  end

  def tile_at(x,y)
    @blueprint[x][y]
  end

  PlayerCollision = Class.new(StandardError)
end
