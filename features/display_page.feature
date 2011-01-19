Feature: Display a page

  Background:
    Given I go to the home page
    And I wait for ajax call complete

  @javascript
  Scenario: Display the home.txt page
    When I click the node with path "./home.txt"
    And I wait for ajax call complete

    Then I should have the following open tabs:
      | home |
    And I should see "Sample page" within "h1"
    And I should see "Lorem ipsum.."
    And I should see "Sample section" within "h2"

  @javascript
  Scenario: Display the ./folder/test.txt page
    When I double click the node with path "./folder"
    And I click the node with path "./folder/test.txt"
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
    When I click the node with path "./home.txt"
    And I double click the node with path "./folder"
    And I click the node with path "./folder/test.txt"
    And I wait for ajax call complete

    Then I should have the following open tabs:
      | home |
      | test |
