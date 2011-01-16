Feature: Create page

  Background:
    Given I go to the home page
    And I wait for ajax call complete

  @javascript
  Scenario: Create a new page
    When I right click node "./folder"
    And I follow "Create page"
    Then I should see dialog box titled "Create page"

    When I fill in the dialog box input with "The new page"
    And press "OK"
    And I reload the page
    And I double click node "./folder"
    Then I should see "The new page"

  @javascript
  Scenario: Create a folder
    When I right click node "./folder"
    And I follow "Create folder"
    Then I should see dialog box titled "Create folder"

    When I fill in the dialog box input with "The new folder"
    And press "OK"
    And I reload the page
    And I double click node "./folder"
