require 'open3'
class BrokenGameEngineError < StandardError; end

class Game
  def self.games
    Dir[RobotTournament.base_dir + '/games/*'].map { |path| File.basename(path) }
  end
  
  def initialize(name)
    @game_cmd = games_path + "/#{name}/bin/#{name}"
    unless File.exists?(@game_cmd)
      raise(ArgumentError, "Game '#{name}' not found in #{games_path}")
    end
  end
  
  def play(player1, player2)
    cmd = "#{@game_cmd} #{player1.path} #{player2.path}"
    stdin, stdout, stderr = Open3.popen3(cmd)
    raise(BrokenGameEngineError, stderr.read) if $?.exitstatus != 0
    
    output = stdout.read
    match = /Result: (.*) wins/.match(output)
    winner = match ? match[1] : nil
    [winner, output]
  end
  
  private
  
  def games_path
    RobotTournament.base_dir + '/games'
  end
end