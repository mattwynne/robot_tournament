require 'mustache'
require 'rdiscount'

class GamePage < Mustache
  self.template_path = File.dirname(__FILE__)
  
  def game_details
    markdown = RDiscount.new(Tournament.current.game_details)
    markdown.to_html
  end
end
