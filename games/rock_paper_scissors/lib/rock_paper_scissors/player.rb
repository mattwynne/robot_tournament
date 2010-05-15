require 'tempfile'
require 'timeout'

class FailedToMoveError < StandardError
  def initialize(name, message)
    super(%Q{Player "#{name}" failed to move: #{message}})
  end
end

class Player
  class << self
    attr_accessor :max_move_secs
  end
  
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
    stdout = Timeout.timeout(Player.max_move_secs) do
      Dir.chdir(@path) do
        IO.popen("#{cmd} 2> #{stderr_file.path}", 'r') { |io| io.read }
      end
    end
    stderr = IO.read(stderr_file.path)
    if $?.exitstatus == 0
      observer.result(stdout.strip)
    else
      observer.fail(stderr)
    end
  rescue Timeout::Error
    observer.timeout
  end
  
  def to_s
    name
  end

  def name
    File.basename(@path)
  end
end

Player.max_move_secs = 1