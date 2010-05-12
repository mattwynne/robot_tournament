Feature: Play game

  Background:
    Given a player "always-rock" who moves like this:
      """
      #!/usr/bin/env ruby
      puts "rock"
      """
    And a player "always-paper" who moves like this:
      """
      #!/usr/bin/env ruby
      puts "paper"
      """

  Scenario: Winner
    When a game is played between "always-rock" and "always-paper"
    Then I should see:
      """
      always-rock: rock
      always-paper: paper
      Result: always-paper wins
      
      """
  Scenario: Draw
    When a game is played between "always-rock" and "always-rock"
    Then I should see:
      """
      always-rock: rock
      always-rock: rock
      Result: draw
      """