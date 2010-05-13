class MatchResult < Struct.new(:player1, :player2, :winner, :output); end

class RoundRunner
  def initialize(player_store, game, observer)
    @player_store, @game, @observer = player_store, game, observer
  end
  
  def start!
    results = []
    each_pair do |player1, player2|
      winner, output = @game.play(player1, player2)
      results << [ player1.name, player2.name, winner, output ]
    end
    @observer.results!(results)
    @observer.league_table!(process_results(results))
  end
  
  private
  
  def process_results(results)
    points = Hash.new(0)
    results.each do |player1, player2, winner|
      if winner
        points[winner] += 3
      else
        points[player1] += 1
        points[player2] += 1
      end
    end
    points.to_a.sort { |a,b| a[1] <=> b[1] }.reverse
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