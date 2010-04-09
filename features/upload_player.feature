Feature: Upload player
  In order to be able to play
  As a competitor
  I want to be able to upload a player

  Scenario: Upload a valid but very simple player
    Given a file named "bash_robot/move" with:
      """
      #!/usr/bin/env bash
      echo "ready"
      
      """
    When I zip up the folder and upload the data to '/players'
    Then the response should be 200 OK
    And I should see "ready" in the response
    
  Scenario: Upload a valid and more complex player
    Given a file named "ruby_robot/move" with:
      """
      #!/usr/bin/env ruby
      puts "ready"
      
      """
    When I zip up the folder and upload the data to '/players'
    Then the response should be 200 OK
    And I should see "ready" in the response

  Scenario: Upload a Haskell player
    Given a file named "haskell_robot/move" with:
      """
      #!/usr/bin/env bash
      runhaskell move.hs
  
      """
    And a file named "haskell_robot/move.hs" with:
      """
      main = putStr "ready"
      
      """
    When I zip up the folder and upload the data to '/players'
    Then the response should be 200 OK
    And I should see "ready" in the response
