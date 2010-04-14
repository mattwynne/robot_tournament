class Player
  attr_reader :name
  
  def initialize(path)
    @path = File.expand_path(path)
    `chmod +x #{move_cmd}`
  end
  
  def name
    File.basename(@path)
  end
  
  def move
    `#{move_cmd}`
  end
  
  private 
  
  def move_cmd
    "#{@path}/move"
  end
end