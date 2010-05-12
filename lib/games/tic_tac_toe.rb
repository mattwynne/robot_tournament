# This is the engine for running games of tic-tac-toe between two players.
# Passed the paths to two players, it will play the game and report the result.
# 
# The board cells are referenced as follows:
# 012
# 345
# 678
# 
# e.g. tic-tac-toe player_a player_b
# player_a: 0
# player_b: 1
# player_a: 3
# player_b: 4
# player_a: 6
# winner: player_a

$: << File.dirname(__FILE__) + '/tic_tac_toe'
require 'players'
require 'game'
require 'stdout_reporter'