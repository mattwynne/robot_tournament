require 'zip/zip'
require 'zip/zipfilesystem'

class PlayerUpload
  def initialize(raw)
    @raw = raw
  end
  
  def process!
    PlayerStore.new.store(self)
  end
  
  def name
    player_name
  end
  
  def unpack
    `unzip #{temp_file.path}`
  end
  
  def response
    player = PlayerStore.new.players.find { |p| p.name == name }
    if player
      "Received new player #{name} (#{player.test})"
    else
      raise("Player '#{name}' failed to upload (but we don't know why, sorry)")
    end
  end
  
  private
  
  def player_name
    @player_name ||= with_zip { |zip| zip.dir.entries('.').first }
  end

  def with_zip
    Zip::ZipFile.open(temp_file.path) do |zip|
      yield zip
    end
  end
  
  def temp_file
    return @temp_file if @temp_file
    @temp_file = Tempfile.new('new_player.zip')
    @temp_file << @raw
    @temp_file.close
    @temp_file
  end
end