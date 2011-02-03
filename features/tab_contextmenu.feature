Feature: Tab Panel

  Background:
    Given I open the application

  Scenario Outline: Close tab
    When I open the page for the tree node with path "<path>"
    And I right click the tab with path "<path>"
    And I follow "Close Tab"
    Then I should have no open tabs

  Examples:
    | path                        |
    | ./home.txt                  |
    | ./test.txt                  |
    | ./folder/test 1.txt         |
    | ./folder/test 2.txt         |
    | ./folder/test.txt           |
    | ./folder/subfolder/ruby.txt |

  Scenario Outline: Close other tabs
    When I open the page for the tree node with path "./home.txt"
    When I open the page for the tree node with path "./folder/subfolder/ruby.txt"
    And I open the page for the tree node with path "./test.txt"
    And I right click the tab with path "<path>"
    And I follow "Close Other Tabs"

    Then I should have the following open tabs:
      | <title> |
    And I should see active tab titled "<title>"

  Examples:
    | path                        | title |
    | ./home.txt                  | home  |
    | ./folder/subfolder/ruby.txt | ruby  |
    | ./test.txt                  | test  |

  Scenario: Close all tabs
    When I open the page for the tree node with path "./home.txt"
    When I open the page for the tree node with path "./folder/subfolder/ruby.txt"
    And I open the page for the tree node with path "./test.txt"
    And I right click the tab with path "./test.txt"
    And I follow "Close All Tabs"
    Then I should have no open tabs
