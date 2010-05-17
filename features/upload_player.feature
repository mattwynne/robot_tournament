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

  Scenario: Upload a Ruby Player
    Given a file named "ruby_robot/move" with:
      """
      #!/usr/bin/env ruby
      puts "rock"
      
      """
    When I zip up the folder and upload the data to "/players"
    Then the response should be 200 OK
    And I should see "ruby_robot" in the response
