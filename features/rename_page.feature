Feature: Rename

  Background:
    Given I go to the home page
    And I wait for ajax call complete

  @javascript
  Scenario: Rename a page
    When I right click node "./home.txt"
    And I follow "Rename node"
    Then I should see dialog box titled "Rename node"

    When I fill in the dialog box input with "The new home"
    And press "OK"
    And I reload the page
    And I should see "The new home"

    When I click node "./The new home.txt"
    And I wait for ajax call complete
    Then I should see "Sample page" within "h1"

  @javascript
  Scenario: Rename a page when tab is open
    When I click node "./home.txt"
    And I click node "./test.txt"
    And I right click node "./home.txt"
    And I follow "Rename node"
    Then I should see dialog box titled "Rename node"

    When I fill in the dialog box input with "The new home"
    And press "OK"
    Then I should have the following open tabs:
      | The new home |
      | test         |

  @javascript
  Scenario: Rename a folder
    When I right click node "./folder"
    And I follow "Rename node"
    Then I should see dialog box titled "Rename node"

    When I fill in the dialog box input with "The new folder name"
    And press "OK"
    Then I should see "The new folder name"

    When I double click node "./The new folder name"
    And I click node "./The new folder name/test.txt"
    And I wait for ajax call complete
    Then I should see "Test 1" within "h3"
    