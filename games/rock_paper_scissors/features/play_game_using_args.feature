Feature: Play game using args
  Background:
    Given a player "rock-when-hot" who moves like this:
      """
      #!/usr/bin/env ruby
      puts "rock" and exit 0 if ARGV[0] == "sunny"
      puts "scissors"
      """
    And a player "paper-when-hot" who moves like this:
      """
      #!/usr/bin/env ruby
      puts "paper" and exit 0 if ARGV[0] == "sunny"
      puts "scissors"
      """

  Scenario: Sunny Day
    When a game is played between "rock-when-hot" and "paper-when-hot" with the weather "sunny"
    Then I should see:
      """
      rock-when-hot: rock
      paper-when-hot: paper
      Result: paper-when-hot wins
    
      """
      
  Scenario: Rainy Day
    When a game is played between "rock-when-hot" and "paper-when-hot" with the weather "rainy"
    Then I should see:
      """
      rock-when-hot: scissors
      paper-when-hot: scissors
      Result: draw
  
      """
