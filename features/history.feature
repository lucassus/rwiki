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
    And I wait for load the page

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

