@rack_test
Feature: Upload player
  In order to be able to play
  As a competitor
  I want to be able to upload a player
  
  Scenario: Successfully upload a player to a tournament
    Given a Tournament "foo" with the following attributes:
      | rounds   | 1                   |
      | duration | 10                  |
      | game     | rock_paper_scissors |
    And a file named "ruby_robot/move" with:
      """
      #!/usr/bin/env ruby
      puts "rock"
      
      """
    When I zip up the folder and upload the data to "/players"
    Then the response should be 200 OK
    And I should see "ruby_robot" in the response

  Scenario: Upload a player when there's no tournament
    And a file named "ruby_robot/move" with:
      """
      #!/usr/bin/env ruby
      puts "rock"
    
      """
    When I zip up the folder and upload the data to "/players"
    Then the response should be 500 NOT OK
    And I should see "no tournament" in the response
  