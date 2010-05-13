Feature: Play tournament
  In order to find out who has the best robot
  As a player
  I want tournaments dammit
  
  Scenario: Two players, one obvious winner
    Given a Tournament "foo" with the following attributes:
      | rounds   | 1                   |
      | duration | 10                  |
      | game     | rock_paper_scissors |
    And a player 'always-rock' who always says 'rock'
    And a player 'always-paper' who always says 'paper'
    When 10 minutes pass
    And I go to the homepage
    Then I should see that 'always-paper' is the winner
