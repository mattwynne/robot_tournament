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
      my_symbol = "x" if board.count("o") > board.count("x")
      my_symbol ||= "o"

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
      my_symbol = "x" if board.count("o") > board.count("x")
      my_symbol ||= "o"

      puts moves[board.count(my_symbol).to_i]
      """
  
  Scenario: Player 1 wins
    When a game is played between "downwards" and "next_free_space"
    Then I should see exactly:
      """
      player o: 'downwards'
      player x: 'next_free_space'
      ---------
      o move: 0
      o--------
      x move: 1
      ox-------
      o move: 3
      ox-o-----
      x move: 2
      oxxo-----
      o move: 6
      oxxo--o--
      Result: o wins
      
      """

  Scenario: Draw
    When a game is played between "next_free_space" and "blocker"
    Then I should see exactly:
      """
      player o: 'next_free_space'
      player x: 'blocker'
      ---------
      o move: 0
      o--------
      x move: 1
      ox-------
      o move: 2
      oxo------
      x move: 3
      oxox-----
      o move: 4
      oxoxo----
      x move: 6
      oxoxo-x--
      o move: 5
      oxoxoox--
      x move: 8
      oxoxoox-x
      o move: 7
      oxoxooxox
      Result: draw
      
      """

  Scenario: Player attempts to go on already occupied square
    When a game is played between "blocker" and "blocker"
    Then I should see exactly:
      """
      player o: 'blocker'
      player x: 'blocker'
      ---------
      o move: 1
      -o-------
      x move: 1
      FOUL! player x has attempted to play on an already-taken space and loses by default
      -o-------
      Result: o wins
      
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
      player o: 'mistaken'
      player x: 'blocker'
      ---------
      o move: 99 flake
      FOUL! player o has attempted to play an illegal move and loses by default
      ---------
      Result: x wins
      
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
      player o: 'buggy'
      player x: 'blocker'
      ---------
      o move: this is my exception
      FOUL! player o has returned a non-zero exit status and loses by default
      ---------
      Result: x wins
    
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
      player o: 'crap'
      player x: 'blocker'
      ---------
      o move: this is my weak error handling
      FOUL! player o has returned a non-zero exit status and loses by default
      ---------
      Result: x wins
  
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
      player o: 'blocker'
      player x: 'slow'
      ---------
      o move: 1
      -o-------
      x move: 
      FOUL! player x has taken more than 1.0 second(s) to move and loses by default
      -o-------
      Result: o wins
    
      """
