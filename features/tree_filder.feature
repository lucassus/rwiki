Feature: Tree Filter

  Background:
    Given I open the application

  Scenario: Filtering
    When I fill in the tree filter with "ruby"
    Then I should see "ruby"
