class Round
  def initialize(path)
    @path = path
  end
  
  def started?
    File.exists?(@path + '/started')
  end
  
  def start_time
    Time.parse(File.read(@path + '/start_time'))
  end
  
  def store_player_upload(upload)
    player_store.store(upload)
  end
  
  private
  
  def player_store
    @player_store ||= PlayerStore.new(@path)
  end
end
