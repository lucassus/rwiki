Feature: Tree Panel

  Background:
    Given I open the application

  @javascript
  Scenario: Find a page
    When I press "Find page"
    And I fill in the input with "test" within the dialog box
    