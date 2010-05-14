require 'tempfile'

class FailedToMoveError < StandardError
  def initialize(name, message)
    super(%Q{Player "#{name}" failed to move: #{message}})
  end
end

class Player
  def initialize(path)
    @path = path
  end
  
  def report_to(reporter)
    reporter.player(name)
  end
  
  def move(observer)
    stderr_file = Tempfile.new('game')
    stderr_file.close
    
    cmd = "#{@path}/move"
    stdout = IO.popen("#{cmd} 2> #{stderr_file.path}", 'r') { |io| io.read }
    stderr = IO.read(stderr_file.path)
    if $?.exitstatus == 0
      observer.result(stdout.strip)
    else
      observer.fail(stderr)
    end
  end
  
  def to_s
    name
  end

  def name
    File.basename(@path)
  end
end