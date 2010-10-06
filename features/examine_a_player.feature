Feature: Examine a player
  In order to figure out how my player is doing against other players
  As a competitor
  I want to examine exactly how my player has done in each match
  
  Background:
    Given a Tournament "foo" with the following attributes:
      | rounds   | 3                   |
      | duration | 1                   |
      | game     | rock_paper_scissors |
    And a player "always-rock" who always says "rock"
    And a player "friendly" who always says "hello"
    And a player "always-paper" who always says "paper"
    And the first round has been played
  
  Scenario: Navigate to the page for the previous round
    When I go to the homepage
    And I follow "always-rock"
    Then I should see that there are 4 results