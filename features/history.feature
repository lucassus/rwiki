Feature: History

  Background:
    Given I open the application

  Scenario: Open page with path given in the url
    When I open the application for page with path "./home.txt"

    Then I should have the following open tabs:
      | home |
    And the node with path "./home.txt" should be selected
    Then I should see "Sample page" within "h1"
    And I should see generated content for the node with path "./home.txt"

  Scenario Outline: After reload the application last opened page should be loaded
    When I open the page for the tree node with path "<path>"
    And I reload the application

    Then I should see active tab titled "<title>"
    And I should see page title "Rwiki <path>"
    And I should see generated content for the node with path "<path>"
    And the node with path "<path>" should be selected

  Examples:
    | path                        | title  |
    | ./home.txt                  | home   |
    | ./test.txt                  | test   |
    | ./folder/test.txt           | test   |
    | ./folder/test 1.txt         | test 1 |
    | ./folder/test 2.txt         | test 2 |
    | ./folder/subfolder/ruby.txt | ruby   |

  Scenario: Browser history
    When I open the page for the tree node with path "./folder/test.txt"
    And I open the page for the tree node with path "./test.txt"
    And I open the page for the tree node with path "./home.txt"
    Then I should see active tab titled "home"

    And I press the browser back button
    Then the node with path "./test.txt" should be selected
    And I should see generated content for the node with path "./test.txt"
    And I should see active tab titled "test"

    When I press the browser back button
    Then the node with path "./folder/test.txt" should be selected
    And I should see generated content for the node with path "./folder/test.txt"
    And I should see active tab titled "test"

    When I press the browser forward button
    Then the node with path "./test.txt" should be selected
    And I should see generated content for the node with path "./test.txt"
    And I should see active tab titled "test"

    When I create a new page titled "A new page" for the node with path "./Info"
    And I press the browser back button
    And I press the browser forward button
    Then the node with path "./Info/A new page.txt" should be selected
    And I should see generated content for the node with path "./Info/A new page.txt"
    And I should see active tab titled "A new page"
