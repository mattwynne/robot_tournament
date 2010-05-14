class Move
  class NeedToExecute < StandardError; end
  include Comparable
  
  attr_reader :player
  
  def initialize(player, reporter)
    @player = player
    @reporter = reporter
  end
  
  def <=>(other)
    raise(NeedToExecute) unless @value
    return 0 if other.value == self.value
    case @value
    when "fail"
      return -1
    when "rock"
      return (other.value == "paper")    ? -1 : 1
    when "paper"
      return (other.value == "scissors") ? -1 : 1
    when "scissors"
      return (other.value == "rock")     ? -1 : 1
    end
    raise("don't know how to compare #{other.value} with #{@value}")
  end
  
  def to_s
    @value
  end
  
  def execute
    @player.move(self)
    self
  end
  
  def result(value)
    @value = value
    @reporter.move(@player.name, value)
    @reporter.invalid(@player.name) unless valid?
    self
  end
  
  def fail(message)
    @value = "fail"
    @reporter.move(@player.name, message)
    @reporter.fail(@player.name, "returned a non-zero exit status")
    self
  end
  
  def timeout
    @value = "fail"
    @reporter.fail(@player.name, "taken more than #{Player.max_move_secs} second(s) to move")
    self
  end
  
  protected
  attr_reader :value
  
  private
  def valid?
    ["rock", "paper", "scissors"].include?(@value)
  end
end

