Feature: Tab Panel

  Background:
    Given I open the application

  Scenario Outline: Close tab from context menu
    When I open the page for the tree node with path "<path>"
    And I right click the tab with path "<path>"
    And I follow "Close Tab"
    Then I should have no open tabs

  Examples:
    | path                        |
    | ./home.txt                  |
    | ./test.txt                  |
    | ./test.txt                  |
    | ./folder/test 1.txt         |
    | ./folder/test 2.txt         |
    | ./folder/test.txt           |
    | ./folder/subfolder/ruby.txt |

  Scenario: Close other tabs from context menu

  Scenario: Close all tabs from context menu
    