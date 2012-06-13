# This is the engine for running games of maze pathfinding between two players.
# Passed the paths to two players, it will play the game and report the result.
#
# See features for more details
# 
$: << File.dirname(__FILE__) + '/maze'
require 'players'
require 'map'
require 'map_loader'
require 'game'
require 'stdout_reporter'
