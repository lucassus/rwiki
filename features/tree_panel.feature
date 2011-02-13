Feature: Tree Panel

  Background:
    Given I open the application

  Scenario: Browsing the root node
    Then for the node with path "/Home" I should see following nodes:
      | Development    |
      | Personal stuff |
      | About          |
    And I should not see the node titled "Ruby"
    And I should not see the node titled "Addresses"

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

  Scenario Outline: Move the node
    When I move the node with path "<path>" to "<new_parent_path>"
    And I reload the application
    And I open the page for the tree node with path "<new_path>"
    Then I should see generated content for the node with path "<new_path>"

  Examples:
    | path                                         | new_parent_path      | new_path                         |
    | /Home/Personal stuff                         | /Home/Development    | /Home/Development/Personal stuff |
    | /Home/Development                            | /Home/Personal stuff | /Home/Personal stuff/Development |
    | /Home/About                                  | /Home/Personal stuff | /Home/Personal stuff/About       |
    | /Home/Personal stuff/Notes                   | /Home/Development    | /Home/Development/Notes          |
    | /Home/Development/Programming Languages/Ruby | /Home                | /Home/Ruby                       |
