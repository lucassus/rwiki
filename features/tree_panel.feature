Feature: Tree Panel

  Background:
    Given I open the application

  Scenario: Browsing the root node
    Then for the tree node "/Home" I should see following nodes:
      | About          |
      | Development    |
      | Personal stuff |
    And I should not see the tree node titled "Ruby"
    And I should not see the tree node titled "Addresses"

  Scenario: Expand the "/Home/Personal stuff" node
    When I expand the tree node "/Home/Personal stuff"
    Then for the tree node "/Home/Personal stuff" I should see following nodes:
      | Addresses |
      | Notes     |

  Scenario: Expand the "/Home/Development" node
    When I expand the tree node "/Home/Development"
    And I expand the tree node "/Home/Development/Programming Languages"
    Then for the tree node "/Home/Development/Programming Languages" I should see following nodes:
      | Java       |
      | JavaScript |
      | Python     |
      | Ruby       |
