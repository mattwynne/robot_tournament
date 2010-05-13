Feature: Start tournament
  In order to get things underway
  As an admin
  I want be able to start a tournament
  
  Scenario: Tournament with 3 rounds
    When I create a new Tournament "foo" with the following attributes:
      | rounds   | 3                   |
      | duration | 10                  |
      | game     | rock_paper_scissors |
    When I go to the homepage
    Then I should see that the Tournament "foo" is in progress
    And I should see that the first Round will begin in less than 10 minutes