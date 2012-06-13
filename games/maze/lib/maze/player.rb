require 'tempfile'
require 'timeout'

class Player
  class << self
    attr_accessor :max_move_secs
  end
  max_move_secs = 1

  attr_reader :symbol
  def initialize(path, symbol)
    @path = path
    @symbol = symbol
  end

  def report_to(reporter)
    reporter.player(name, @symbol)
  end

  def move(board, reporter)
    stderr_file = Tempfile.new('game')
    stderr_file.close

    cmd = "#{@path}/move \"#{board.state(symbol)}\""

    stdout = Dir.chdir(@path) do
      Timeout.timeout(Player.max_move_secs) do
        IO.popen("#{cmd} 2> #{stderr_file.path}", 'r') { |io| io.read }
      end
    end
    stderr = IO.read(stderr_file.path)

    if $?.exitstatus == 0
      board.move!(stdout, @symbol)
    else
      board.loser!(stdout + stderr, @symbol, "returned a non-zero exit status")
    end
  rescue Timeout::Error
    board.loser!("", @symbol, "taken longer than #{Player.max_move_secs} second(s) to move")
  end

  def name
    File.basename(@path)
  end
end
