require 'tempfile'
class Player
  attr_reader :symbol
  def initialize(path, symbol)
    @path = path
    @symbol = symbol
  end
  
  def report_to(reporter)
    reporter.player(name, @symbol)
  end
  
  def move(board)
    stderr_file = Tempfile.new('game')
    stderr_file.close
    
    cmd = "#{@path}/move #{board.state}"
    stdout = IO.popen("#{cmd} 2> #{stderr_file.path}", 'r') { |io| io.read }
    stderr = IO.read(stderr_file.path)
    raise("failed to call player #{@path}: #{stderr}") unless $?.exitstatus == 0

    stdout.to_i
  end

  private
  
  def name
    File.basename(@path)
  end
  
end