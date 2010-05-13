require 'robot_tournament/player_upload'
require 'robot_tournament/validation_error'

class PlayerUploadHandler
  def initialize(raw)
    @upload = PlayerUpload.new(raw)
  end
  
  def process
    unless @upload.valid?
      raise(ValidationError, @upload.validation_error_message)
    end
    
    player = PlayerStore.new.store(@upload)
    return "Received new player '#{player.name}' OK\n"
  end
end