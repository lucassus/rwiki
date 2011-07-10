Feature: Move the tree node

  Background:
    Given I open the application

  Scenario Outline: Move the tree node
    When I expand the parent for the tree node "<path>"
    And I expand the parent for the tree node "<new_parent_path>"
    And I move the tree node "<path>" to the tree node "<new_parent_path>"

    When I wait for move the page
    And I reload the application
    And I open the page "<new_path>"
    Then I should see a content for the page "<new_path>"

  Examples:
    | path                                         | new_parent_path      | new_path                         |
    | /Home/Personal stuff                         | /Home/Development    | /Home/Development/Personal stuff |
    | /Home/Development                            | /Home/Personal stuff | /Home/Personal stuff/Development |
    | /Home/About                                  | /Home/Personal stuff | /Home/Personal stuff/About       |
    | /Home/Personal stuff/Notes                   | /Home/Development    | /Home/Development/Notes          |
    | /Home/Development/Programming Languages/Ruby | /Home                | /Home/Ruby                       |

  Scenario Outline: Move the node when tabs are opened
    When I open the page "/Home/Development/Programming Languages/Java"
    And I open the page "/Home/Development/Programming Languages/JavaScript"
    And I open the page "/Home/Development/Programming Languages/Python"
    And I open the page "/Home/Development/Programming Languages/Ruby"

    When I move the tree node "/Home/Development/Programming Languages" to the tree node "/Home"

    When I click a tab for page "<path>"
    Then I should see a content for the page "<path>"

  Examples:
    | path                                   |
    | /Home/Programming Languages/Java       |
    | /Home/Programming Languages/JavaScript |
    | /Home/Programming Languages/Python     |
    | /Home/Programming Languages/Ruby       |
