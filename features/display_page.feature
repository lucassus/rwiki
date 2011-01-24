Feature: Display a page

  Background:
    Given I open the application

  @javascript
  Scenario: Display the home.txt page
    When I click the node with path "./home.txt"

    Then I should have the following open tabs:
      | home |
    And I should see page title "Rwiki ./home.txt"
    And I should see generated content for the node with path "./home.txt"

  @javascript
  Scenario: Display the ./folder/test.txt page
    When I double click the node with path "./folder"
    And I click the node with path "./folder/test.txt"

    Then I should have the following open tabs:
      | test |
    And I should see page title "Rwiki ./folder/test.txt"
    And I should see generated content for the node with path "./folder/test.txt"

  @javascript
  Scenario: Display the several page
    When I click the node with path "./home.txt"
    And I double click the node with path "./folder"
    And I click the node with path "./folder/test.txt"

    Then I should have the following open tabs:
      | home |
      | test |
    And I should see page title "Rwiki ./folder/test.txt"
    And I should see generated content for the node with path "./folder/test.txt"
