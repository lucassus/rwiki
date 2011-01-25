Feature: Display a page

  Background:
    Given I open the application

  @javascript
  Scenario Outline: Display the page
    When I open the page for the tree node with path "<path>"
    Then I should see active tab titled "<title>"

  Examples:
    | path                        | title  |
    | ./home.txt                  | home   |
    | ./test.txt                  | test   |
    | ./folder/test.txt           | test   |
    | ./folder/test 1.txt         | test 1 |
    | ./folder/test 2.txt         | test 2 |
    | ./folder/subfolder/ruby.txt | ruby   |

  @javascript
  Scenario: Display the several pages
    When I open the page for the tree node with path "./home.txt"
    And I open the page for the tree node with path "./folder/test.txt"
    And I open the page for the tree node with path "./folder/subfolder/ruby.txt"

    Then I should have the following open tabs:
      | home |
      | test |
      | ruby |
    Then I should see active tab titled "ruby"
    And I should see page title "Rwiki ./folder/subfolder/ruby.txt"
    And I should see generated content for the node with path "./folder/subfolder/ruby.txt"
