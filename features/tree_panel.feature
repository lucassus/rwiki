Feature: Tree Panel

  Background:
    Given I open the application

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
