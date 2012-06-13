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
    axis = ['E', 'W'].include?(direction) ? 1 : 0
    movement = ['N', 'W'].include?(direction) ? -1 : 1

    new_position = @positions[player].dup
    new_position[axis] += movement

    @positions[player] = new_position if @blueprint[new_position.first][new_position.last] == '.'
    return nil
  end

end
