Feature: Tab Panel

  Background:
    Given I open the application

  Scenario Outline: Close tab
    When I open the node with path "<path>"
    And I right click the tab with path "<path>"
    And I follow "Close Tab"
    Then I should have no open tabs

  Examples:
    | path                                         |
    | /Home                                        |
    | /Home/About                                  |
    | /Home/Personal stuff/Notes                   |
    | /Home/Development/Programming Languages      |
    | /Home/Personal stuff/Addresses               |
    | /Home/Development/Programming Languages/Ruby |

  Scenario Outline: Close other tabs
    When I open the node with path "/Home"
    When I open the node with path "/Home/Development/Programming Languages/Ruby"
    And I open the node with path "/Home/About"
    And I right click the tab with path "<path>"
    And I follow "Close Other Tabs"

    Then I should have the following open tabs:
      | <title> |
    And I should see active tab titled "<title>"

  Examples:
    | path                                         | title |
    | /Home                                        | Home  |
    | /Home/Development/Programming Languages/Ruby | Ruby  |
    | /Home/About                                  | About |

  Scenario: Close all tabs
    When I open the node with path "/Home"
    When I open the node with path "/Home/Development/Programming Languages/Ruby"
    And I open the node with path "/Home/About"
    And I right click the tab with path "/Home/About"
    And I follow "Close All Tabs"
    Then I should have no open tabs
