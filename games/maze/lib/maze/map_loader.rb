class MapLoader
  attr :blueprint
  attr :players_start

  def initialize(path)
    @blueprint = ""
    @players_start = []
    File.read(path).lines.each do |line|
      if (m = line.match(/^Player (\d): (\d+),(\d+)/))
        @players_start << [m[2].to_i, m[3].to_i]
      else
        @blueprint += line
      end
    end
    @blueprint.chomp!
  end
end
