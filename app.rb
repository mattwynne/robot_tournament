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
        `#{@upload.manifest['test_cmd']}`
      end
    end
  end
end

class PlayerUpload
  def initialize(raw)
    @raw = raw
  end
  
  def player_name
    manifest unless @manifest
    @player_name
  end
  
  def manifest
    @manifest ||= with_zip do |zip|
      @player_name = zip.dir.entries('.').first
      manifest_file = zip.find_entry("#{@player_name}/manifest")
      manifest_file.get_input_stream do |io|
        YAML.load(io.read)
      end
    end
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