# This is the engine for running games of tic-tac-toe between two players.
# Passed the paths to two players, it will play the game and report the result.
#
# See features for more details
# 
$: << File.dirname(__FILE__) + '/tic_tac_toe'
require 'players'
require 'game'
require 'stdout_reporter'