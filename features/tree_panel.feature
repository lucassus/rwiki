Feature: Tree Panel

  Background:
    Given I go to the home page
    And I wait for ajax call complete

  @javascript
  Scenario: Browsing a tree
    Then I should see "empty_folder"
    And I should see node "folder"
    And I should see node "subfolder"
    And I should see node "home"
    And I should see node "test"

    And I should not see node "ruby"
    And I should not see node "test 1"
    And I should not see node "test 2"

    When I double click node "./folder"
    Then I should see node "test"
    And I should see node "test 1"
    And I should see node "test 2"

    When I double click node "./folder/subfolder"
    Then I should see node "ruby"
