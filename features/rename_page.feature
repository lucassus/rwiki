Feature: Rename a node

  Background:
    Given I go to the home page
    And I wait for ajax call complete

  @javascript
  Scenario: Rename a page
    When I right click the node with path "./home.txt"
    And I follow "Rename node"
    Then I should see dialog box titled "Rename node"

    When I fill in the dialog box input with "The new home"
    And press "OK"
    Then I should see the node titled "The new home"

    When I reload the page
    Then I should see the node titled "The new home"

    When I click the node with path "./The new home.txt"
    And I wait for ajax call complete
    Then I should see "Sample page" within "h1"

  @javascript
  Scenario: Rename a page to existing name
    When I right click the node with path "./home.txt"
    And I follow "Rename node"
    Then I should see dialog box titled "Rename node"

    When I fill in the dialog box input with "test"
    And press "OK"
    And I reload the page
    And I should see "home"
    And I should see "test"

    When I click the node with path "./home.txt"
    And I wait for ajax call complete
    Then I should see "Sample page" within "h1"

    When I click the node with path "./test.txt"
    And I wait for ajax call complete
    Then I should see "This is a test"
    And I should see page title "Rwiki ./test.txt"
    And I should have the following open tabs:
      | home |
      | test |

  @javascript
  Scenario: Rename a page when tab is open
    When I click the node with path "./test.txt"
    And I click the node with path "./home.txt"
    Then I should see page title "Rwiki ./home.txt"

    And I right click the node with path "./home.txt"
    And I follow "Rename node"
    Then I should see dialog box titled "Rename node"

    When I fill in the dialog box input with "The new home"
    And press "OK"
    Then I should see the node titled "The new home"
    And I should have the following open tabs:
      | test         |
      | The new home |
    And I should see page title "Rwiki ./The new home.txt"

  @javascript
  Scenario: Rename a folder
    When I right click the node with path "./folder"
    And I follow "Rename node"
    Then I should see dialog box titled "Rename node"

    When I fill in the dialog box input with "The new folder name"
    And press "OK"
    Then I should see the node titled "The new folder name"

    When I double click the node with path "./The new folder name"
    And I click the node with path "./The new folder name/test.txt"
    And I wait for ajax call complete
    Then I should see "Test 1" within "h3"

    When I reload the page
    Then I should see the node titled "The new folder name"
    And I double click the node with path "./The new folder name"
    And I click the node with path "./The new folder name/test.txt"
    And I wait for ajax call complete
    Then I should see "Test 1" within "h3"
    