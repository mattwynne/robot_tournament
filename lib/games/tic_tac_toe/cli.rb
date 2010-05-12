require 'rubygems'
require 'trollop'

Trollop.options
Trollop.die "Need two players" unless ARGV.length == 2

reporter = StdoutReporter.new
players = Players.new(ARGV[0..1], reporter)
game = Game.new(players)
game.play(reporter)