require 'rubygems'
require 'zip/zip'
require 'zip/zipfilesystem'
require 'player_store'
require 'validation_error'

class PlayerUpload
  def initialize(raw)
    @raw = raw
  end
  
  def valid?
    validation_error_message.nil?
  end
  
  def validation_error_message
    with_zip do |zip|
      root_entries = zip.dir.entries('.')
      
      unless root_entries.any?
        return "The zip file is empty" 
      end
      unless root_entries.length == 1 and zip.file.directory?(root_entries.first)
        return "The zip file must contain a single directory in the root"
      end
      
      player_name = root_entries.first
      player_entries = zip.dir.entries(player_name)
      
      unless player_entries.include?('play')
        return "The '#{player_name}' folder must contain a 'play' command file"
      end
    end
    nil
  end
  
  def unpack
    raise(ValidationError, validation_error_message) unless valid?
    FileUtils.rm_rf player_name
    `unzip #{zip_file.path}`
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