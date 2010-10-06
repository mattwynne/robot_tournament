Feature: Examine a round
  In order to see what happened in a particular round
  As a competitor
  I want a special page for each round, showing me what happened
  
  Background:
    Given a Tournament "foo" with the following attributes:
      | rounds   | 3                   |
      | duration | 1                   |
      | game     | rock_paper_scissors |
    And a player "always-rock" who always says "rock"
    And a player "friendly" who always says "hello"
    And a player "always-paper" who always says "paper"
    And the first round has been played
    
  Scenario:
    When I go to the homepage
    And I follow "Round 1"
    Then I should see 6 results
