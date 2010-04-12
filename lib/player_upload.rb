require 'rubygems'
require 'zip/zip'
require 'zip/zipfilesystem'

class PlayerUpload
  def initialize(raw)
    @raw = raw
  end
  
  def process!
    PlayerStore.new.store(self)
  end
  
  def validation_error
    nil
  end
  
  def unpack
    `unzip #{zip_file.path}`
  end
  
  def response
    player = PlayerStore.new.players.find { |p| p.name == player_name }
    if player
      "Received new player #{player_name}"
    else
      raise("Player '#{name}' failed to upload (but we don't know why, sorry)")
    end
  end
  
  private
  
  def player_name
    @player_name ||= with_zip { |zip| zip.dir.entries('.').first }
  end

  def with_zip
    Zip::ZipFile.open(zip_file.path) do |zip|
      yield zip
    end
  end
  
  def zip_file
    return @zip_file if @zip_file
    @zip_file = Tempfile.new('new_player.zip')
    @zip_file << @raw
    @zip_file.close
    @zip_file
  end
end