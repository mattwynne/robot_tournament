Feature: Play tournament
  In order to find out who has the best robot
  As a player
  I want tournaments dammit
  
  Scenario: Two players, one obvious winner
    Given a tournament 'rock-paper-scissors' with 1 round
    And a player 'always-rock' who always says 'rock'
    And a player 'always-paper' who always says 'paper'
    When the tournament is played
    Then the player 'always-paper' should be the winner
