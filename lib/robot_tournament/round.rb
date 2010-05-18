require 'robot_tournament/round_runner'
require 'robot_tournament/game'
require 'time'

class Round
  attr_reader :start_time
  
  def initialize(path)
    @path = path
    read_settings!
  end
  
  def name
    "Round #{number}"
  end
  
  def <=>(other)
    number <=> other.number
  end
  
  def number
    raw_name = File.basename(@path)
    num = /^round_(\d+)$/.match(raw_name)
    num[1].to_i
  end
  
  def to_s
    name
  end
  
  def kick
    start! if due?
  end
  
  def started?
    File.exists?(@path + '/started')
  end
  
  def finished?
    File.exists?(@path + '/results.json')
  end
  
  def store_player_upload(upload)
    player_store.store(upload)
  end
  
  def players
    player_store.players
  end
  
  def results
    read_json(:results)
  end
  
  def results!(results)
    write_json(:results, results)
  end
  
  def league_table
    read_json(:league_table)
  end
  
  def league_table!(league_table)
    write_json(:league_table, league_table)
  end
  
  private
  
  def write_json(file_name, content)
    File.open(@path + "/#{file_name}.json", 'w') do |io|
      io.puts(content.to_json)
    end
  end
  
  def read_json(file_name)
    JSON.parse(File.read(@path + "/#{file_name}.json"))
  end
  
  def read_settings!
    settings = read_json(:settings)
    @game       = settings["game"]
    @start_time = Time.parse(settings["start_time"])
  end
  
  def due?
    @start_time < Time.now
  end
  
  def start!
    FileUtils.touch(@path + '/started')
    RoundRunner.new(player_store, Game.new(@game), self).start!
  end
  
  def player_store
    @player_store ||= PlayerStore.new(@path + '/players')
  end
end
