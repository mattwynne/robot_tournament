require 'open3'
class BrokenGameEngineError < StandardError; end

class Game
  def self.games
    Dir[RobotTournament.base_dir + '/games/*'].map { |path| File.basename(path) }
  end

  def initialize(name)
    @path = games_path + "/#{name}"
    @game_cmd = "#{@path}/bin/#{name}"

    unless File.exists?(@game_cmd)
      raise(ArgumentError, "Game '#{name}' not found in #{games_path}")
    end
  end

  def details
    File.read("#{@path}/readme.markdown")
  end

  def play(player1, player2)
    cmd = "#{@game_cmd} #{player1.path} #{player2.path}"

    stderr_file = Tempfile.new('game')
    stderr_file.close

    stdout = IO.popen("#{cmd} 2> #{stderr_file.path}", 'r') { |io| io.read }
    stderr = IO.read(stderr_file.path)

    raise(BrokenGameEngineError, stderr) if $?.exitstatus != 0

    output = stdout
    match = /Result: (.*) wins/.match(output)
    winner = match ? match[1] : nil
    [winner, output]
  end

  private

  def games_path
    RobotTournament.base_dir + '/games'
  end
end
