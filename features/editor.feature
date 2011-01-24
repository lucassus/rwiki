Feature: Editing a page

  Background:
    Given I open the application

  @javascript
  Scenario: Invoke the editor window
    When I click the node with path "./home.txt"
    And I press "Edit the page"
    Then I should see the window titled "Editing page ./home.txt"

  @javascript
  Scenario: Edit and save the page
    When I click the node with path "./home.txt"
    And I press "Edit the page"
    Then I should see the window titled "Editing page ./home.txt"

    When I fill in "editor" with "h1. A new page header"
    And I press "Save"
    Then I should not see the window
    And I should see "A new page header" within "h1"
    And I should see generated content for the node with path "./home.txt"

    When I reload the application
    Then I should see "A new page header" within "h1"
    And I should see generated content for the node with path "./home.txt"

  @javascript
  Scenario: Edit and Save and continue
    When I click the node with path "./home.txt"
    And I press "Edit the page"
    Then I should see the window titled "Editing page ./home.txt"

    When I fill in "editor" with "h1. A new page header"
    And I press "Save and continue"
    Then I should see the window titled "Editing page ./home.txt"
    And I should see "A new page header" within "h1"
    And I should see generated content for the node with path "./home.txt"

  @javascript
    Scenario: Edit and Cancel
    When I click the node with path "./home.txt"
    And I press "Edit the page"
    Then I should see the window titled "Editing page ./home.txt"

    When I fill in "editor" with "h1. A new page header"
    And I press "Cancel"
    Then I should see "Sample page" within "h1"
    And I should see generated content for the node with path "./home.txt"
