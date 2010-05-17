require 'json'
require 'chronic_duration'
require 'time'
require 'robot_tournament/round'

class Tournament
  class << self
    def kick
      current.kick
    end
    
    def current
      TournamentStore.new.current
    end
  end
  attr_reader :name
  
  def initialize(path)
    @path = path
    read_settings!
  end
  
  def start!
    FileUtils.touch(@path + '/started')
    create_rounds
  end
  
  def kick
    return unless next_round
    next_round.kick
  end
  
  def store_player_upload(upload)
    return unless next_round
    next_round.store_player_upload(upload)
  end
  
  def seconds_until_next_round
    return nil unless next_round
    (next_round.start_time - Time.now).to_i
  end
  
  def next_round
    rounds.detect { |round| !round.started? }
  end
  
  def rounds
    path = @path + '/round_*'
    Dir[path].sort.map { |path| Round.new(path) }
  end
  
  private
  
  def create_rounds
    @num_rounds.times do |index|
      num = index + 1
      round_path = @path + "/round_#{num}"
      FileUtils.mkdir_p(round_path)
      settings = {
        "start_time" => Time.now + (@duration * 60 * num),
        "game"       => @game
      }
      File.open(round_path + '/settings.json', 'w') do |file|
        file.puts(settings.to_json)
      end
    end
  end
  
  def read_settings!
    settings = JSON.parse(File.read(@path + '/settings.json'))
    @name = settings["name"]
    @num_rounds = settings["rounds"].to_i
    @duration = settings["duration"].to_i
    @game = settings["game"]
  end
end