require 'rubygems'
require 'sinatra'
require 'tempfile'
require 'zip/zip'
require 'zip/zipfilesystem'
require 'yaml'

class Player
  def initialize(upload)
    @upload = upload
    @name = upload.player_name || raise("Player has no name!")
  end
  
  def test
    Dir.chdir(File.expand_path(File.dirname(__FILE__) + '/players')) do
      FileUtils.rm_rf(@name)
      @upload.unpack
      Dir.chdir(@name) do
        `chmod +x move`
        `./move`
      end
    end
  end
end

class PlayerUpload
  def initialize(raw)
    @raw = raw
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

post '/players' do
  raw = request.env["rack.input"].read
  upload = PlayerUpload.new(raw)
  player = Player.new(upload)
  player.test
end