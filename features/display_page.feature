Feature: Display the page

  Background:
    Given I open the application

  Scenario Outline: Display the page
    When I open the page "<path>"
    Then I should see active tab titled "<title>"
    And I should see a content for the page  "<path>"

  Examples:
    | path                                         | title                 |
    | /Home                                        | Home                  |
    | /Home/About                                  | About                 |
    | /Home/Personal stuff/Addresses               | Addresses             |
    | /Home/Personal stuff/Notes                   | Notes                 |
    | /Home/Development/Programming Languages      | Programming Languages |
    | /Home/Development/Programming Languages/Ruby | Ruby                  |

  Scenario: Display the several pages
    When I open the page "/Home"
    And I open the page "/Home/Personal stuff/Addresses"
    And I open the page "/Home/Development/Programming Languages/Ruby"

    Then I should have the following open tabs:
      | Home      |
      | Addresses |
      | Ruby      |
    Then I should see active tab titled "Ruby"
    And I should see the application title "Rwiki /Home/Development/Programming Languages/Ruby"
    And I should see a content for the page  "/Home/Development/Programming Languages/Ruby"
