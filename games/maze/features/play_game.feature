Feature: Play game

  Background:
    Given a player "always-east" who moves like this:
      """
      #!/usr/bin/env ruby
      board_state = ARGV[0]
      puts "E"
      """
    And a player "always-south" who moves like this:
      """
      #!/usr/bin/env ruby
      board_state = ARGV[0]
      puts "S"
      """
  Scenario: Player 1 wins
    When a game is played between "always-east" and "always-south"
    Then I should see exactly:
      """
      player 1: 'always-east'
      player 2: 'always-south'
      You are player 1
      ***********
      *......M..*
      3...***...F
      *.........*
      ***********
      1 move: E
      You are player 2
      ***********
      *......M..*
      21..***...F
      *.........*
      ***********
      2 move: S
      Result: always-east wins
      """

  Scenario: Draw
    When a game is played between "always-east" and "always-east"
    Then I should see exactly:
      """
      player 1: 'always-east'
      player 2: 'always-east'
      You are player 1
      ***********
      *......M..*
      3...***...F
      *.........*
      ***********
      1 move: E
      You are player 2
      ***********
      *......M..*
      3...***...F
      *.........*
      ***********
      2 move: E
      You are player 1
      ***********
      *......M..*
      .3..***...F
      *.........*
      ***********
      1 move: E
      You are player 2
      ***********
      *......M..*
      .3..***...F
      *.........*
      ***********
      2 move: E
      You are player 1
      ***********
      *......M..*
      ..3.***...F
      *.........*
      ***********
      1 move: E
      You are player 2
      ***********
      *......M..*
      ..3.***...F
      *.........*
      ***********
      2 move: E
      You are player 1
      ***********
      *......M..*
      ...3***...F
      *.........*
      ***********
      1 move: E
      You are player 2
      ***********
      *......M..*
      ...3***...F
      *.........*
      ***********
      2 move: E
      You are player 1
      ***********
      *......M..*
      ...3***...F
      *.........*
      ***********
      1 move: E
      You are player 2
      ***********
      *......M..*
      ...3***...F
      *.........*
      ***********
      2 move: E
      Result: draw
      """
  Scenario: Player makes an illegal move
    Given a player "mistaken" who moves like this:
      """
      #!/usr/bin/env ruby
      puts "99 flake"

      """
    When a game is played between "mistaken" and "always-east"
    Then I should see exactly:
      """
      player 0: 'mistaken'
      player x: 'always-east'
      You are player 1
      ***********
      *......M..*
      3...***...F
      *.........*
      ***********
      1 move: 99 flake
      FOUL! player 0 has attempted to play an illegal move and loses by default
      Result: blocker wins
      """
  Scenario: Player dies and throws an exception to STDERR
    Given a player "buggy" who moves like this:
      """
      #!/usr/bin/env ruby
      STDERR.puts "this is my exception"
      exit 1

      """
    When a game is played between "buggy" and "always-east"
    Then I should see exactly:
      """
      player 1: 'buggy'
      player 2: 'always-east'
      You are player 1
      ***********
      *......M..*
      3...***...F
      *.........*
      ***********
      1 move: this is my exception
      FOUL! player 1 has returned a non-zero exit status and loses by default
      ---------
      Result: always-east wins
    
      """
  Scenario: Player takes too long to make a move
    Given the maximum seconds allowed for a move is "1.0"
    And a player "slow" who moves like this:
      """
      #!/usr/bin/env ruby
      sleep 1

      """
    When a game is played between "blocker" and "slow"
    Then I should see exactly:
      """
      player 1: 'slow'
      player 2: 'always-east'
      You are player 1
      ***********
      *......M..*
      3...***...F
      *.........*
      ***********
      1 move: 
      FOUL! player x has taken longer than 1.0 second(s) to move and loses by default
      Result: always-east wins
      """
