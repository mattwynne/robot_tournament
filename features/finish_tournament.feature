Feature: Finish tournament
  In order to find out WHO IS THE BEST
  As a player
  I want the tournament to finish
  
  Scenario: Two players, one obvious winner
    Given a Tournament "foo" with the following attributes:
      | rounds   | 2                   |
      | duration | 10                  |
      | game     | rock_paper_scissors |
    And a player 'always-rock' who always says 'rock'
    And a player 'always-paper' who always says 'paper'
    When 10 minutes pass
    And the engine is kicked
    And 11 minutes pass
    And the engine is kicked
    And I go to the homepage
    Then I should see that the tournament has finished
    Then I should see that 'always-paper' is the winner
    And I should see that 2 rounds were played
    And I should see that 2 matches were played in each round
