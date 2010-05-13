require 'json'
require 'chronic_duration'
require 'time'
require 'robot_tournament/round'

class Tournament
  attr_reader :name
  
  def initialize(path)
    @path = path
    read_settings!
  end
  
  def start!
    FileUtils.touch(@path + '/started')
    @num_rounds.times do |index|
      num = index + 1
      round_path = @path + "/round_#{num}"
      FileUtils.mkdir_p(round_path)
      File.open(round_path + '/start_time', 'w') do |file|
        file.puts(Time.now + (@duration * 60))
      end
    end
  end
  
  def duration_until_next_round
    wait = (next_round.start_time - Time.now).to_i
    ChronicDuration.output(wait, :format => :long)
  end
  
  def store_player_upload(upload)
    next_round.store_player_upload(upload)
  end
  
  private
  
  def next_round
    rounds.detect { |round| !round.started? }
  end
  
  def rounds
    path = @path + '/round_*'
    Dir[path].sort.map { |path| Round.new(path) }
  end
  
  def read_settings!
    settings = JSON.parse(File.read(@path + '/settings.json'))
    @name = settings["name"]
    @num_rounds = settings["rounds"].to_i
    @duration = settings["duration"].to_i
  end
end