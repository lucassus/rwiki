Feature: Internal links

  Background:
    Given I open the application

  Scenario: Open the page via internal link
    When I open the page for the tree node with path "/Home"
    And I follow "Ruby notes"
    Then I should see the page "/Home/Development/Programming Languages/Ruby"
