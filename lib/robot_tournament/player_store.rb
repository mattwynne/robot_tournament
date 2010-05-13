require 'robot_tournament/player'

class PlayerStore
  def initialize(dir = nil)
    @dir = File.expand_path(dir || default_dir)
    FileUtils.mkdir_p(@dir)
  end
  
  def store(upload)
    Dir.chdir(@dir) do
      upload.unpack
    end
    players.find{ |p| p.name == upload.player_name }
  end
  
  def players
    Dir.chdir(@dir) do
      Dir['*'].map{ |dir| Player.new(dir) }
    end
  end
  
  def clear
    FileUtils.rm_rf(@dir)
    FileUtils.mkdir_p(@dir)
  end
  
  private
  
  def default_dir
    File.dirname(__FILE__) + '/../tmp/players'
  end
end