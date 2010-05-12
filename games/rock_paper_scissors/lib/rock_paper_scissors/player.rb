require 'tempfile'
class Player

  def initialize(path)
    @path = path
  end
  
  def report_to(reporter)
    reporter.player(name)
  end
  
  def move
    stderr_file = Tempfile.new('game')
    stderr_file.close
    
    cmd = "#{@path}/move"
    stdout = IO.popen("#{cmd} 2> #{stderr_file.path}", 'r') { |io| io.read }
    stderr = IO.read(stderr_file.path)
    raise("failed to call player #{@path}: #{stderr}") unless $?.exitstatus == 0

    stdout.strip
  end
  
  def to_s
    name
  end

  def name
    File.basename(@path)
  end
end