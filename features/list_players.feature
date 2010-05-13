Feature: List players
  In order to see all the players in the tournament
  As a competitor
  I want a list of players
  
  Scenario: Two players
    Given there is a tournament
    Given there is a player "mattbot"
    And there is a player "danbot"
    When I go to the homepage
    Then I should see the following players listed:
      | mattbot |
      | danbot  |
