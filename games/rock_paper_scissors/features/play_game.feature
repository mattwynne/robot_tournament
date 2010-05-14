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
      
  Scenario: Forfeit for invalid move
    And a player "idiot" who moves like this:
      """
      #!/usr/bin/env ruby
      puts "hello"
      """
    When a game is played between "always-rock" and "idiot"
    Then I should see exactly:
      """
      always-rock: rock
      idiot: hello
      Player 'idiot' has made an invalid move and has forfeited the game.
      Result: always-rock wins
      
      """

  Scenario: Forfeit for no response
    And a player "mute" who moves like this:
      """
      #!/usr/bin/env ruby
      """
    When a game is played between "always-rock" and "mute"
    Then I should see exactly:
      """
      always-rock: rock
      mute:
      Player 'mute' has made an invalid move and has forfeited the game.
      Result: always-rock wins
      
      """

  Scenario: Forfeit for timeout
    And a player "slow" who moves like this:
      """
      #!/usr/bin/env ruby
      wait 2
      """
    When a game is played between "always-rock" and "slow"
    Then I should see exactly:
      """
      always-rock: rock
      Player 'slow' has taken more than 1 second to move and has forfeited the game.
      Result: always-rock wins
      
      """

  Scenario: Forfeit for being broken
    And a player "broken" who moves like this:
      """
      #!/usr/bin/env ruby
      STDERR.puts "argh I am dying"
      exit 1
      """
    When a game is played between "always-rock" and "broken"
    Then I should see exactly:
      """
      always-rock: rock
      broken: argh I am dying
      Player 'broken' has returned a non-zero exit status and has forfeited the game.
      Result: always-rock wins
      
      """
