Feature: Tree Panel

  Background:
    Given I go to the home page
    And I wait for ajax call complete

  @javascript
  Scenario: Browsing a tree
    Then I should see "empty_folder"
    And I should see the node titled "folder"
    And I should see the node titled "subfolder"
    And I should see the node titled "home"
    And I should see the node titled "test"

    And I should not see the node titled "ruby"
    And I should not see the node titled "test 1"
    And I should not see the node titled "test 2"

    When I double click the node with path "./folder"
    Then I should see the node titled "test"
    And I should see the node titled "test 1"
    And I should see the node titled "test 2"

    When I double click the node with path "./folder/subfolder"
    Then I should see the node titled "ruby"
