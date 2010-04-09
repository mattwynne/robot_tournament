require 'zip/zip'
require 'zip/zipfilesystem'

class PlayerUpload
  def initialize(raw)
    @raw = raw
  end
  
  def process!
    player_store.store(Player.new(player_name))
  end
  
  def response
    "ready"
  end
  
  private
  
  def player_store
    PlayerStore.new
  end
  
  def player_name
    @player_name ||= with_zip { |zip| zip.dir.entries('.').first }
  end

  def unpack
    `unzip #{temp_file.path}`
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