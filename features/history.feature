Feature: History

  Background:
    Given I open the application

  Scenario Outline: Open page with path given in the url
    When I open the application for page "<path>"

    Then I should have the following open tabs:
      | <title> |
    And the tree node "<path>" should be selected
    And I should see a content for the page "<path>"

  Examples:
    | path                                         | title                 |
    | /Home                                        | Home                  |
    | /Home/About                                  | About                 |
    | /Home/Personal stuff/Addresses               | Addresses             |
    | /Home/Personal stuff/Notes                   | Notes                 |
    | /Home/Development/Programming Languages      | Programming Languages |
    | /Home/Development/Programming Languages/Ruby | Ruby                  |

  Scenario Outline: After reload the application last opened page should be loaded
    When I open the page "<path>"
    And I reload the application

    Then I should see active tab titled "<title>"
    And I should see the application title "Rwiki <path>"
    And I should see a content for the page "<path>"
    And the tree node "<path>" should be selected

  Examples:
    | path                                         | title                 |
    | /Home                                        | Home                  |
    | /Home/About                                  | About                 |
    | /Home/Personal stuff/Addresses               | Addresses             |
    | /Home/Personal stuff/Notes                   | Notes                 |
    | /Home/Development/Programming Languages      | Programming Languages |
    | /Home/Development/Programming Languages/Ruby | Ruby                  |

  Scenario: Browser history
    When I open the page "/Home/Personal stuff/Addresses"
    And I open the page "/Home/About"
    And I open the page "/Home"
    Then I should see active tab titled "Home"

    And I press the browser back button
    Then the tree node "/Home/About" should be selected
    And I should see a content for the page "/Home/About"
    And I should see active tab titled "About"

    When I press the browser back button
    Then the tree node "/Home/Personal stuff/Addresses" should be selected
    And I should see a content for the page "/Home/Personal stuff/Addresses"
    And I should see active tab titled "Addresses"

    When I press the browser forward button
    Then the tree node "/Home/About" should be selected
    And I should see a content for the page "/Home/About"
    And I should see active tab titled "About"

    When I create a new page titled "A new page" for the parent "/Home"
    And I press the browser back button
    And I press the browser forward button
    Then the tree node "/Home/A new page" should be selected
    And I should see a content for the page "/Home/A new page"
    And I should see active tab titled "A new page"
