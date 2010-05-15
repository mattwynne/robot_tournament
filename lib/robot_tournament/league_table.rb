class LeagueTable
  def initialize(raw)
    @raw = raw
  end
  
  def leaders
    result = []
    @raw.each do |row|
      result << row["player"] if row["points"] == max_points
    end
    result
  end
  
  def max_points
    @raw.first["points"]
  end
end