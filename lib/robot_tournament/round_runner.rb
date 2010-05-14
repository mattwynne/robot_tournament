class MatchResult < Struct.new(:player1, :player2, :winner, :output); end

class RoundRunner
  def initialize(player_store, game, observer)
    @player_store, @game, @observer = player_store, game, observer
  end
  
  def start!
    results = []
    each_pair do |player1, player2|
      winner, output = @game.play(player1, player2)
      winner = winner.name if winner.respond_to?(:name)
      results << {
        "player1" => player1.name,
        "player2" => player2.name,
        "winner"  => winner,
        "output"  => output
      }
    end
    @observer.results!(results)
    @observer.league_table!(process_results(results))
  end
  
  private
  
  def process_results(results)
    points = Hash.new(0)
    players.each { |player| points[player.name] = 0 }
    results.each do |result|
      if result["winner"]
        points[result["winner"]] += 3
      else
        points[result["player1"]] += 1
        points[result["player2"]] += 1
      end
    end
    table = points.to_a.sort { |a,b| a[1] <=> b[1] }.reverse
    table.map { |player, points| { "player" => player, "points" => points } }
  end
  
  def players
    @player_store.players
  end
  
  def each_pair
    players.each do |player1|
      players.each do |player2|
        yield player1, player2 unless player1 == player2
      end
    end
  end
end