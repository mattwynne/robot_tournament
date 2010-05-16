Feature: Play game

  Background:
    Given a player "next_free_space" who moves like this:
      """
      #!/usr/bin/env ruby
      board_state = ARGV[0]
      puts board_state.index("-")
      """
    And a player "downwards" who moves like this:
      """
      #!/usr/bin/env ruby
      board = ARGV[0]
      my_symbol = "x" if board.count("0") > board.count("x")
      my_symbol ||= "0"

      # have I been yet?
      if board.index(my_symbol).nil?
        # go in first free square
        puts board.index("-")
      else
        puts(board.rindex(my_symbol) + 3)
      end
      """
    And a player "blocker" who moves like this:
      """
      #!/usr/bin/env ruby
      board = ARGV[0]
      
      # -x-
      # x--
      # x-x
      moves = [1,3,6,8]
      my_symbol = "x" if board.count("0") > board.count("x")
      my_symbol ||= "0"

      puts moves[board.count(my_symbol).to_i]
      """
  
  Scenario: Player 1 wins
    When a game is played between "downwards" and "next_free_space"
    Then I should see exactly:
      """
      player 0: 'downwards'
      player x: 'next_free_space'
      ---------
      0 move: 0
      0--------
      x move: 1
      0x-------
      0 move: 3
      0x-0-----
      x move: 2
      0xx0-----
      0 move: 6
      0xx0--0--
      Result: downwards wins
      
      """

  Scenario: Draw
    When a game is played between "next_free_space" and "blocker"
    Then I should see exactly:
      """
      player 0: 'next_free_space'
      player x: 'blocker'
      ---------
      0 move: 0
      0--------
      x move: 1
      0x-------
      0 move: 2
      0x0------
      x move: 3
      0x0x-----
      0 move: 4
      0x0x0----
      x move: 6
      0x0x0-x--
      0 move: 5
      0x0x00x--
      x move: 8
      0x0x00x-x
      0 move: 7
      0x0x00x0x
      Result: draw
      
      """

  Scenario: Player attempts to go on already occupied square
    When a game is played between "blocker" and "blocker"
    Then I should see exactly:
      """
      player 0: 'blocker'
      player x: 'blocker'
      ---------
      0 move: 1
      -0-------
      x move: 1
      FOUL! player x has attempted to play on an already-taken space and loses by default
      -0-------
      Result: blocker wins
      
      """
  
  Scenario: Player makes an illegal move
    Given a player "mistaken" who moves like this:
      """
      #!/usr/bin/env ruby
      puts "99 flake"

      """
    When a game is played between "mistaken" and "blocker"
    Then I should see exactly:
      """
      player 0: 'mistaken'
      player x: 'blocker'
      ---------
      0 move: 99 flake
      FOUL! player 0 has attempted to play an illegal move and loses by default
      ---------
      Result: blocker wins
      
      """
  
  Scenario: Player dies and throws an exception to STDERR
    Given a player "buggy" who moves like this:
      """
      #!/usr/bin/env ruby
      STDERR.puts "this is my exception"
      exit 1

      """
    When a game is played between "buggy" and "blocker"
    Then I should see exactly:
      """
      player 0: 'buggy'
      player x: 'blocker'
      ---------
      0 move: this is my exception
      FOUL! player 0 has returned a non-zero exit status and loses by default
      ---------
      Result: blocker wins
    
      """
  
  Scenario: Player dies and throws an exception to STDOUT
    Given a player "crap" who moves like this:
      """
      #!/usr/bin/env ruby
      puts "this is my weak error handling"
      exit 1

      """
    When a game is played between "crap" and "blocker"
    Then I should see exactly:
      """
      player 0: 'crap'
      player x: 'blocker'
      ---------
      0 move: this is my weak error handling
      FOUL! player 0 has returned a non-zero exit status and loses by default
      ---------
      Result: blocker wins
  
      """
  
  Scenario: Player takes too long to make a move
    Given the maximum seconds allowed for a move is 1.0
    And a player "slow" who moves like this:
      """
      #!/usr/bin/env ruby
      sleep 1

      """
    When a game is played between "blocker" and "slow"
    Then I should see exactly:
      """
      player 0: 'blocker'
      player x: 'slow'
      ---------
      0 move: 1
      -0-------
      x move: 
      FOUL! player x has taken more than 1.0 second(s) t0 move and loses by default
      -0-------
      Result: o wins
    
      """
