Feature: Tree Panel

  Background:
    Given I open the application

  @javascript
  Scenario: Find a page
    When I press "Find page"
    And I fill in the input with "test" within the dialog box
    And I select the first search result

    Then I should have the following open tabs:
      | home |
    And I should see page title "Rwiki ./test.txt"
    And I should see generated content for the node with path "./test.txt"
