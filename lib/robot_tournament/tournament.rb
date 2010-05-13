require 'json'

class Tournament
  attr_reader :name
  
  def initialize(path)
    settings = JSON.parse(File.read(path + 'settings.json'))
    @name = settings["name"]
  end
  
  def start
    
  end
end