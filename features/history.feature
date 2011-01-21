Feature: History

  Background:
    Given I open the application

  @javascript
  Scenario: Open page with path given in the url
    When I open the application for page with path "./home.txt"

    Then I should have the following open tabs:
      | home |
    And the node with path "./home.txt" should be selected
    Then I should see "Sample page" within "h1"

  @javascript
  Scenario: After reload the application last opened page should be loaded
    When I double click the node with path "./folder"
    And I click the node with path "./folder/test.txt"
    And I reload the application

    Then I should have the following open tabs:
      | test |
    And I should see page title "Rwiki ./folder/test.txt"
    And I should see "Test 1" within "h3"
    And the node with path "./folder/test.txt" should be selected

  @javascript
  Scenario: Browser history
    When I double click the node with path "./folder"
    And I click the node with path "./folder/test.txt"
    And I click the node with path "./test.txt"
    And I click the node with path "./home.txt"

    When I press the browser back button
    Then the node with path "./test.txt" should be selected

    When I press the browser back button
    Then the node with path "./folder/test.txt" should be selected

    When I press the browser forward button
    Then the node with path "./test.txt" should be selected

    When I create a new page title "A new page" for the node with path "./Info"
    And I press the browser back button
    And I press the browser forward button
    Then the node with path "./Info/A new page.txt" should be selected
