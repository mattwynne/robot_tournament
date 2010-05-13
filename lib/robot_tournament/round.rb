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
end
