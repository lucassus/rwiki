Feature: Tree Panel

  Background:
    Given I open the application

  Scenario: Browsing the root node
    Then for the node with path "/Home" I should see following nodes:
      | Development    |
      | Personal stuff |
      | About          |
    And I should not see the node titled "ruby"
    And I should not see the node titled "test 1"
    And I should not see the node titled "test 2"

  Scenario: Expand the "/Home/Personal stuff" node
    When I expand the node with path "/Home/Personal stuff"
    Then for the node with path "/Home/Personal stuff" I should see following nodes:
      | Addresses |
      | Notes     |

  Scenario: Expand the "/Home/Development" node
    When I expand the node with path "/Home/Development"
    And I expand the node with path "/Home/Development/Programming Languages"
    Then for the node with path "/Home/Development/Programming Languages" I should see following nodes:
      | Java       |
      | JavaScript |
      | Python     |
      | Ruby       |

  Scenario Outline: Move a page
    Given this scenario is pending
    When I move the node with path "<path>" to "<parent_path>"
    And I reload the application
    And I open the page for the tree node with path "<new_path>"
    Then I should see generated content for the node with path "<new_path>"

  Examples:
    | path                                         | parent_path                    | new_path                                  |
    | /Home                                        | /Home/Personal stuff           | /Home/Personal stuff/home.txt             |
    | /Home                                        | /Home/Personal stuff/subfolder | /Home/Personal stuff/subfolder/home.txt   |
    | /Home/About                                  | ./subfolder                    | ./subfolder/test.txt                      |
    | /Home/Personal stuff/Notes                   | /Home/Personal stuff/subfolder | /Home/Personal stuff/subfolder/test 1.txt |
    | /Home/Development/Programming Languages/Ruby | .                              | ./ruby.txt                                |

  Scenario: Move a folder
    Given this scenario is pending
    When I move the node with path "/Home/Personal stuff" to "./subfolder"
    And I reload the application

    When I open the page for the tree node with path "./subfolder/folder/test.txt"
    Then I should see generated content for the node with path "./subfolder/folder/test.txt"

    When I open the page for the tree node with path "./subfolder/folder/test 1.txt"
    Then I should see generated content for the node with path "./subfolder/folder/test 1.txt"

    When I open the page for the tree node with path "./subfolder/folder/test 2.txt"
    Then I should see generated content for the node with path "./subfolder/folder/test 2.txt"

    When I open the page for the tree node with path "./subfolder/folder/subfolder/ruby.txt"
    Then I should see generated content for the node with path "./subfolder/folder/subfolder/ruby.txt"
