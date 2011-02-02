Feature: Tree Panel

  Background:
    Given I open the application

  Scenario: Browsing the root node
    Then for the node with path "." I should see following nodes:
      | empty_folder |
      | folder       |
      | Info         |
      | subfolder    |
      | home         |
      | test         |
    And I should not see the node titled "ruby"
    And I should not see the node titled "test 1"
    And I should not see the node titled "test 2"

  Scenario: Expand the "./folder" node
    When I expand the node with path "./folder"
    Then for the node with path "./folder" I should see following nodes:
      | subfolder |
      | test      |
      | test 1    |
      | test 2    |

  Scenario: Expand the "./folder/subfolder" node
    When I expand the node with path "./folder"
    And I expand the node with path "./folder/subfolder"
    Then for the node with path "./folder/subfolder" I should see following nodes:
      | ruby |

  Scenario Outline: Move a page
    When I move the node with path "<path>" to "<parent_path>"
    And I reload the application
    And I open the page for the tree node with path "<new_path>"
    Then I should see generated content for the node with path "<new_path>"

  Examples:
    | path                        | parent_path        | new_path                      |
    | ./home.txt                  | ./folder           | ./folder/home.txt             |
    | ./home.txt                  | ./folder/subfolder | ./folder/subfolder/home.txt   |
    | ./test.txt                  | ./subfolder        | ./subfolder/test.txt          |
    | ./folder/test 1.txt         | ./folder/subfolder | ./folder/subfolder/test 1.txt |
    | ./folder/subfolder/ruby.txt | .                  | ./ruby.txt                    |

  Scenario: Move a folder
    When I move the node with path "./folder" to "./subfolder"
    And I reload the application

    When I open the page for the tree node with path "./subfolder/folder/test.txt"
    Then I should see generated content for the node with path "./subfolder/folder/test.txt"

    When I open the page for the tree node with path "./subfolder/folder/test 1.txt"
    Then I should see generated content for the node with path "./subfolder/folder/test 1.txt"

    When I open the page for the tree node with path "./subfolder/folder/test 2.txt"
    Then I should see generated content for the node with path "./subfolder/folder/test 2.txt"

    When I open the page for the tree node with path "./subfolder/folder/subfolder/ruby.txt"
    Then I should see generated content for the node with path "./subfolder/folder/subfolder/ruby.txt"
