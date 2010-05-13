class Player
  attr_reader :name
  attr_reader :path
  
  def initialize(path)
    @path = File.expand_path(path)
    `chmod +x #{cmd}` if File.exists?(cmd)
  end
  
  def name
    File.basename(@path)
  end
  
  def ==(other)
    return false unless other.respond_to?(:path)
    other.path == @path
  end
  
  private
  
  def cmd
    "#{@path}/move"
  end
end