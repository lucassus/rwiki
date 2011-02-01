Feature: Tree Panel

  Background:
    Given I open the application

  @javascript
  Scenario: Browsing a tree
    Then I should see "empty_folder"
    And I should see the node titled "folder"
    And I should see the node titled "subfolder"
    And I should see the node titled "home"
    And I should see the node titled "test"

    And I should not see the node titled "ruby"
    And I should not see the node titled "test 1"
    And I should not see the node titled "test 2"

    When I double click the node with path "./folder"
    Then I should see the node titled "test"
    And I should see the node titled "test 1"
    And I should see the node titled "test 2"

    When I double click the node with path "./folder/subfolder"
    Then I should see the node titled "ruby"

  @javascript
  Scenario Outline: Move a page
    When I move the node with path "<path>" to "<parent_path>"
    And I reload the application
    And I open the page for the tree node with path "<new_path>"
    And I should see generated content for the node with path "<new_path>"

  Examples:
    | path                        | parent_path        | new_path                      |
    | ./home.txt                  | ./folder           | ./folder/home.txt             |
    | ./home.txt                  | ./folder/subfolder | ./folder/subfolder/home.txt   |
    | ./test.txt                  | ./subfolder        | ./subfolder/test.txt          |
    | ./folder/test 1.txt         | ./folder/subfolder | ./folder/subfolder/test 1.txt |
    | ./folder/subfolder/ruby.txt | .                  | ./ruby.txt                    |
