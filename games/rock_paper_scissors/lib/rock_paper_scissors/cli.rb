require 'stdout_reporter'
require 'players'
require 'game'

module Cli
  def self.die(message)
    STDERR.puts(message)
    exit 1
  end
end

unless ARGV.length == 2
  Cli.die("Syntax: rock_paper_scissors path/to/player1 path/to/player2")
end

reporter = StdoutReporter.new
players = Players.new(ARGV[0..1], reporter)
game = Game.new(players)
game.play(reporter)