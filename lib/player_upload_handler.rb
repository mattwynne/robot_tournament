require 'player_upload'
require 'validation_error'

class PlayerUploadHandler
  def initialize(raw)
    @upload = PlayerUpload.new(raw)
  end
  
  def process
    unless @upload.valid?
      raise(ValidationError, @upload.validation_error_message)
    end
    
    PlayerStore.new.store(@upload)
    return "Received new player OK"
  end
end