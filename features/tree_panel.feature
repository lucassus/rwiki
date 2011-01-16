Feature: Tree Panel

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
