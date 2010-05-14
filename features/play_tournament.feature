Feature: Play tournament
  In order to find out who has the best robot
  As a player
  I want tournaments dammit
  
  Scenario: Two players, one obvious winner
    Given a Tournament "foo" with the following attributes:
      | rounds   | 3                   |
      | duration | 1                   |
      | game     | rock_paper_scissors |
    And a player "always-rock" who always says "rock"
    And a player "friendly" who always says "hello"
    When the first round has been played
    And I go to the homepage
    Then I should see that the first round has finished
    And I should see that "always-rock" is winning
    And I should see that the league table looks like:
      | player      | points |
      | always-rock | 6      |
      | friendly    | 0      |
    And I should see that there is 1 round still to be played
    When a player "always-paper" who always says "paper" joins
    And the next round has been played
    And I go to the homepage
    Then I should see that the lead is tied between "always-paper" and "always-rock"
    And I should see that the league table looks like:
      | player       | points |
      | always-paper | 12     |
      | always-rock  | 12     |
      | friendly     | 0      |
    When the next round has been played
    And I go to the homepage
    Then I should see that "always-paper" has won
    And I should see that the league table looks like:
      | player       | points |
      | always-paper | 24     |
      | always-rock  | 18     |
      | friendly     | 0      |
