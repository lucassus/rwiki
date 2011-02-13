Feature: Display the node

  Background:
    Given I open the application

  Scenario Outline: Display the node
    When I open the node with path "<path>"
    Then I should see active tab titled "<title>"
    And I should see a content for the node with path "<path>"

  Examples:
    | path                                         | title                 |
    | /Home                                        | Home                  |
    | /Home/About                                  | About                 |
    | /Home/Personal stuff/Addresses               | Addresses             |
    | /Home/Personal stuff/Notes                   | Notes                 |
    | /Home/Development/Programming Languages      | Programming Languages |
    | /Home/Development/Programming Languages/Ruby | Ruby                  |

  Scenario: Display the several nodes
    When I open the node with path "/Home"
    And I open the node with path "/Home/Personal stuff/Addresses"
    And I open the node with path "/Home/Development/Programming Languages/Ruby"

    Then I should have the following open tabs:
      | Home      |
      | Addresses |
      | Ruby      |
    Then I should see active tab titled "Ruby"
    And I should see the application title "Rwiki /Home/Development/Programming Languages/Ruby"
    And I should see a content for the node with path "/Home/Development/Programming Languages/Ruby"
