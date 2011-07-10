Feature: Rename a node

  # TODO refactor this feature
  Background:
    Given I open the application

  Scenario Outline: Rename a page
    When I open the page "<path>"
    Then I should see the application title "Rwiki <path>"

    When I right click the tree node "<path>"
    And I follow "Rename page"
    Then I should see dialog box titled "Rename page"

    When I fill in the input with "<new_name>" within the dialog box
    And I press "OK" within the dialog box
    And I wait for rename the page
    Then I should see the page titled "<new_name>"
    And I should see the application title "Rwiki <new_path>"
    And I should have the following open tabs:
      | <new_name> |

    When I reload the application
    And I expand the parent for the tree node "<new_path>"
    And I click the tree node "<new_path>"
    Then I should see a content for the page "<new_path>"

  Examples:
    | path                                           | new_name      | new_path                                             |
    | /Home/About                                    | The new About | /Home/The new About                                  |
    | /Home/Development                              | Geek stuff    | /Home/Geek stuff                                     |
    | /Home/Development/Programming Languages        | Programming   | /Home/Development/Programming                        |
    | /Home/Development/Programming Languages/Python | Crunchy frog  | /Home/Development/Programming Languages/Crunchy frog |
    | /Home/Development/Databases                    | DB            | /Home/Development/DB                                 |

  Scenario: Rename a page to existing name
    When I right click the tree node "/Home/About"
    And I follow "Rename page"
    Then I should see dialog box titled "Rename page"

    When I fill in the input with "Personal stuff" within the dialog box
    And I press "OK" within the dialog box
    And I wait for rename the page

    When I reload the application
    And I should see "About"
    And I should see "Personal stuff"

    When I click the tree node "/Home"
    And I should see a content for the page "/Home"

    When I click the tree node "/Home/About"
    Then I should see a content for the page "/Home/About"
    And I should see the application title "Rwiki /Home/About"
    And I should have the following open tabs:
      | Home  |
      | About |

  Scenario Outline: Rename the parent page
    When I open the page "/Home/Development/Programming Languages/Java"
    And I open the page "/Home/Development/Programming Languages/JavaScript"
    And I open the page "/Home/Development/Programming Languages/Python"
    And I open the page "/Home/Development/Programming Languages/Ruby"

    When I right click the tree node "/Home/Development/Programming Languages"
    And I follow "Rename page"
    Then I should see dialog box titled "Rename page"

    When I fill in the input with "Programming" within the dialog box
    And I press "OK" within the dialog box
    And I wait for rename the page

    When I click a tab for page "<path>"
    Then I should see a content for the page "<path>"

  Examples:
    | path                                     |
    | /Home/Development/Programming/Java       |
    | /Home/Development/Programming/JavaScript |
    | /Home/Development/Programming/Python     |
    | /Home/Development/Programming/Ruby       |
