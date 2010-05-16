require 'tempfile'
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
    
    cmd = "#{@path}/move #{board.state}"
    stdout = Dir.chdir(@path) do
      IO.popen("#{cmd} 2> #{stderr_file.path}", 'r') { |io| io.read }
    end
    stderr = IO.read(stderr_file.path)
    
    if $?.exitstatus == 0
      board.move!(stdout, @symbol)
    else
      board.loser!(stdout + stderr, @symbol, "returned a non-zero exit status")
    end
  end

  def name
    File.basename(@path)
  end
end