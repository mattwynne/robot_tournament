require 'robot_tournament/league_table'

class TournamentPresenter
  def initialize(tournament)
    @tournament = tournament
  end
  
  def name
    @tournament.name
  end
  
  def next_round_name
    next_round.name
  end
  
  def unfinished_rounds_count
    remaining_rounds.length
  end
  
  def total_rounds_count
    rounds.length
  end
  
  def remaining_rounds
    rounds.select { |round| !round.finished? }
  end
  
  def finished_rounds?
    finished_rounds.any?
  end
  
  def duration_until_next_round
    return nil unless next_round
    ChronicDuration.output(seconds_until_next_round, :format => :long)
  end
  
  def players
    return nil unless next_round
    next_round.players
  end
  
  def winner?
    league_table.any?
  end
  
  def winner
    return nil unless league_table.any?
    leaders = LeagueTable.new(league_table).leaders
    if leaders.length == 1
      leaders.first
    else
      "it's a tie"
    end
  end
  
  def league_table
    tables = rounds.select { |round| round.finished? }.map { |round| round.league_table }
    points = Hash.new(0)
    tables.each do |table|
      table.each do |row|
        points[row["player"]] += row["points"]
      end
    end
    table = points.to_a.sort{ |a,b| a[0] <=> b[0] }
    table.map { |player, points| { "player" => player, "points" => points } }
  end
  
  def finished_rounds
    rounds.select { |round| round.finished? }
  end
  
  def finished?
    rounds.all? { |round| round.finished? }
  end
  
  private
  
  def rounds
    @tournament.rounds
  end
  
  def next_round
    @tournament.next_round
  end
  
  def seconds_until_next_round
    @tournament.seconds_until_next_round
  end
end