@rack_test
Feature: Upload player
  In order to be able to play
  As a competitor
  I want to be able to upload a player
  
  Background:
    Given a Tournament "foo" with the following attributes:
      | rounds   | 1                   |
      | duration | 10                  |
      | game     | rock_paper_scissors |

  Scenario: Upload a bash player
    Given a file named "bash_robot/move" with:
      """
      #!/usr/bin/env bash
      echo "ready"
      
      """
    When I zip up the folder and upload the data to "/players"
    Then the response should be 200 OK
    And I should see "Received new player 'bash_robot' OK" in the response
    
  Scenario: Upload a Ruby
    Given a file named "ruby_robot/move" with:
      """
      #!/usr/bin/env ruby
      puts "ready"
      
      """
    When I zip up the folder and upload the data to "/players"
    Then the response should be 200 OK
    And I should see "ruby_robot" in the response

  Scenario: Upload a Haskell player
    Given a file named "haskell_robot/move" with:
      """
      #!/usr/bin/env bash
      runhaskell play.hs
  
      """
    And a file named "haskell_robot/move.hs" with:
      """
      main = putStr "ready"
      
      """
    When I zip up the folder and upload the data to "/players"
    Then the response should be 200 OK
    And I should see "haskell_robot" in the response
