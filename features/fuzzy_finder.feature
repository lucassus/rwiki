Feature: Tree Panel

  Background:
    Given I open the application

  Scenario: Find a page
    Given this scenario is pending

    When I press "Find page"
    And I fill in the input with "test" within the dialog box
    And I select the first search result

    Then I should have the following open tabs:
      | home |
    And I should see page title "Rwiki /Home/About"
    And I should see generated content for the node with path "/Home/About"
