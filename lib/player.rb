class Player
  attr_reader :name
  
  def initialize(path)
    @path = path
  end
  
  def name
    File.basename(@path)
  end
end