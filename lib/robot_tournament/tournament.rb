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
    next_round.kick
  end
  
  def duration_until_next_round
    return nil unless next_round
    wait = (next_round.start_time - Time.now).to_i
    ChronicDuration.output(wait, :format => :long)
  end
  
  def players
    return nil unless next_round
    next_round.players
  end
  
  def store_player_upload(upload)
    next_round.store_player_upload(upload)
  end
  
  def winner
    return nil unless league_table.any?
    league_table[0][0]
  end
  
  def league_table
    tables = rounds.select { |round| round.finished? }.map { |round| round.league_table }
    points = Hash.new(0)
    tables.each do |table|
      table.each do |row|
        points[row["player"]] += row["points"]
      end
    end
    points.to_a.sort{ |a,b| a[1] <=> b[1] }
  end
  
  def finished_rounds
    rounds.select { |round| round.finished? }
  end
  
  def finished?
    rounds.all? { |round| round.finished? }
  end
  
  private
  
  def next_round
    rounds.detect { |round| !round.started? }
  end
  
  def rounds
    path = @path + '/round_*'
    Dir[path].sort.map { |path| Round.new(path) }
  end
  
  def create_rounds
    @num_rounds.times do |index|
      num = index + 1
      round_path = @path + "/round_#{num}"
      FileUtils.mkdir_p(round_path)
      settings = {
        "start_time" => Time.now + (@duration * 60),
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