Feature: view pages

  Background:
    Given I go to the home page
    And I wait for ajax call complete

  @javascript
  Scenario: Browsing a tree
    Then I should see "empty_folder"
    And I should see "folder"
    And I should see "subfolder"
    And I should see "home"
    And I should see "test"

    And I should not see "ruby"
    And I should not see "test 1"
    And I should not see "test 2"

    When I double click node "./folder"
    Then I should see "test"
    And I should see "test 1"
    And I should see "test 2"

    When I double click node "./folder/subfolder"
    Then I should see "ruby"

  @javascript
  Scenario: Display the home.txt page
    When I click node "./home.txt"
    And I wait for ajax call complete

    Then I should have the following open tabs:
      | home |
    And I should see "Sample page" within "h1"
    And I should see "Lorem ipsum.."
    And I should see "Sample section" within "h2"

  @javascript
  Scenario: Display the ./folder/test.txt page
    When I double click node "./folder"
    And I click node "./folder/test.txt"
    And I wait for ajax call complete

    Then I should have the following open tabs:
      | test |
    And I should see "Test 1" within "h3"
    And I should see "Item one"
    And I should see "Item two"
    And I should see "Item three"
    And I should see "Last item"

  @javascript
  Scenario: Display the several page
    When I click node "./home.txt"
    And I double click node "./folder"
    And I click node "./folder/test.txt"
    And I wait for ajax call complete

    Then I should have the following open tabs:
      | home |
      | test |

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
  Scenario: Delete a page
    When I right click node "./home.txt"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"

    When I press "Yes"
    And I reload the page
    Then I should not see "home"

  @javascript
  Scenario: Create a folder
    When I right click node "./folder"
    And I follow "Create folder"
    Then I should see dialog box titled "Create folder"

    When I fill in the dialog box input with "The new folder"
    And press "OK"
    And I reload the page
    And I double click node "./folder"

  @javascript
  Scenario: Rename a page
    When I right click node "./home.txt"
    And I follow "Rename node"
    Then I should see dialog box titled "Rename node"

    When I fill in the dialog box input with "The new home"
    And press "OK"
    And I reload the page
    #And I should not see "home"
    And I should see "The new home"

    When I click node "./The new home.txt"
    And I wait for ajax call complete
    Then I should see "Sample page" within "h1"
