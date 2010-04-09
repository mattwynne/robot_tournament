require 'player'

class PlayerStore
  def initialize(dir = nil)
    @dir = dir || 'tmp/players'
    FileUtils.mkdir_p(@dir)
  end
  
  def store(player)
    Dir.chdir(@dir) do
      FileUtils.mkdir(player.name)
    end
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
end