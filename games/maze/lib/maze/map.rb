class Map
  def self.load(path)
  end

  def initialize(blueprint, player1_start, player2_start)
    @blueprint = blueprint.split("\n").map { |row| row.scan(/./) }
    @player1_position = player1_start
    @player2_position = player2_start
  end

  def state
    state = @blueprint.dup
    state[@player1_position.first][@player1_position.last] = '1'
    state[@player2_position.first][@player2_position.last] = '2'
    state.map(&:join).join("\n")
  end
end
