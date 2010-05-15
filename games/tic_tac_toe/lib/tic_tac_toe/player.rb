require 'tempfile'
class Player
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
    Dir.chdir(@path) do
      stdout = IO.popen("#{cmd} 2> #{stderr_file.path}", 'r') { |io| io.read }
    end
    stderr = IO.read(stderr_file.path)
    
    if $?.exitstatus == 0
      handle_good_move(stdout, reporter, board)
    else
      handle_bad_move(stdout + stderr, reporter, board)
    end
  end

  private
  
  def handle_good_move(move, reporter, board)
    reporter.move(move, @symbol)
    board.move!(move, @symbol)
  end
  
  def handle_bad_move(message, reporter, board)
    reporter.move(message, @symbol)
    board.loser!(@symbol, "returned a non-zero exit status")
  end
  
  def name
    File.basename(@path)
  end
  
end