Feature: Editing a page

  Background:
    Given I open the application

  Scenario: Invoke the editor window
    When I click the node with path "/Home"
    And I press "Edit page"
    Then I should see the window titled "Editing page /Home"

  Scenario: Edit and save the page
    When I click the node with path "/Home"
    And I press "Edit page"
    Then I should see the window titled "Editing page /Home"

    When I fill in "editor" with "h1. A new page header"
    And I press "Save"
    Then I should not see the window
    And I should see "A new page header" within "h1"
    And I should see generated content for the node with path "/Home"

    When I reload the application
    Then I should see "A new page header" within "h1"
    And I should see generated content for the node with path "/Home"

  Scenario: Edit and Save and continue
    When I click the node with path "/Home"
    And I press "Edit page"
    Then I should see the window titled "Editing page /Home"

    When I fill in "editor" with "h1. A new page header"
    And I press "Save and continue"
    Then I should see the window titled "Editing page /Home"
    And I should see "A new page header" within "h1"
    And I should see generated content for the node with path "/Home"

    Scenario: Edit and Cancel
    When I click the node with path "/Home"
    And I press "Edit page"
    Then I should see the window titled "Editing page /Home"

    When I fill in "editor" with "h1. A new page header"
    And I press "Cancel"
    Then I should see "This is Rwiki Home Page" within "h1"
    And I should see generated content for the node with path "/Home"
