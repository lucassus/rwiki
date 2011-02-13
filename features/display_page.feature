Feature: Display the page

  Background:
    Given I open the application

  Scenario Outline: Display the page
    When I open the page for the tree node with path "<path>"
    Then I should see active tab titled "<title>"
    And I should see generated content for the node with path "<path>"

  Examples:
    | path                                         | title                 |
    | /Home                                        | Home                  |
    | /Home/About                                  | About                 |
    | /Home/Personal stuff/Addresses               | Addresses             |
    | /Home/Personal stuff/Notes                   | Notes                 |
    | /Home/Development/Programming Languages      | Programming Languages |
    | /Home/Development/Programming Languages/Ruby | Ruby                  |

  Scenario: Display the several pages
    When I open the page for the tree node with path "/Home"
    And I open the page for the tree node with path "/Home/Personal stuff/Addresses"
    And I open the page for the tree node with path "/Home/Development/Programming Languages/Ruby"

    Then I should have the following open tabs:
      | Home      |
      | Addresses |
      | Ruby      |
    Then I should see active tab titled "Ruby"
    And I should see page title "Rwiki /Home/Development/Programming Languages/Ruby"
    And I should see generated content for the node with path "/Home/Development/Programming Languages/Ruby"
