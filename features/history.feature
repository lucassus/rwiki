Feature: History

  Background:
    Given I open the application

  Scenario: Open bide with path given in the url
    When I open the application for node with path "/Home"

    Then I should have the following open tabs:
      | Home |
    And the node with path "/Home" should be selected
    Then I should see "This is Rwiki Home Page" within "h1"
    And I should see a content for the node with path "/Home"

  Scenario Outline: After reload the application last opened page should be loaded
    When I open the node with path "<path>"
    And I reload the application

    Then I should see active tab titled "<title>"
    And I should see the application title "Rwiki <path>"
    And I should see a content for the node with path "<path>"
    And the node with path "<path>" should be selected

  Examples:
    | path                                         | title                 |
    | /Home                                        | Home                  |
    | /Home/About                                  | About                 |
    | /Home/Personal stuff/Addresses               | Addresses             |
    | /Home/Personal stuff/Notes                   | Notes                 |
    | /Home/Development/Programming Languages      | Programming Languages |
    | /Home/Development/Programming Languages/Ruby | Ruby                  |

  Scenario: Browser history
    When I open the node with path "/Home/Personal stuff/Addresses"
    And I open the node with path "/Home/About"
    And I open the node with path "/Home"
    Then I should see active tab titled "Home"

    And I press the browser back button
    Then the node with path "/Home/About" should be selected
    And I should see a content for the node with path "/Home/About"
    And I should see active tab titled "About"

    When I press the browser back button
    Then the node with path "/Home/Personal stuff/Addresses" should be selected
    And I should see a content for the node with path "/Home/Personal stuff/Addresses"
    And I should see active tab titled "Addresses"

    When I press the browser forward button
    Then the node with path "/Home/About" should be selected
    And I should see a content for the node with path "/Home/About"
    And I should see active tab titled "About"

    When I create a new node titled "A new page" for the node with path "/Home"
    And I press the browser back button
    And I press the browser forward button
    Then the node with path "/Home/A new page" should be selected
    And I should see a content for the node with path "/Home/A new page"
    And I should see active tab titled "A new page"
