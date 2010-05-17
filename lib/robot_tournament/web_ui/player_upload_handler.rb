require 'robot_tournament/player_upload'
require 'robot_tournament/validation_error'

class NoCurrentTournament < StandardError
  def initialize
    super("Player upload failed: There is no tournament in progress at the moment.")
  end
end

class PlayerUploadHandler
  def initialize(raw)
    @upload = PlayerUpload.new(raw)
  end
  
  def process
    raise(NoCurrentTournament) unless tournament && tournament.next_round

    unless @upload.valid?
      raise(ValidationError, "Player upload failed: #{@upload.validation_error_message}")
    end
    
    player = tournament.store_player_upload(@upload)
    return "Received new player '#{player.name}' OK\n"
  end
  
  private
  
  def tournament
    @tournament ||= TournamentStore.new.current
  end
end