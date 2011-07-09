Feature: Create a new page

  Background:
    Given I open the application

  Scenario Outline: Create a new page
    When I right click the tree node "<parent_path>"
    And I follow "Add page"
    Then I should see dialog box titled "Add page"

    When I fill in the input with "<new_page_name>" within the dialog box
    And I press "OK" within the dialog box
    And I wait for create the page
    Then I should see the page titled "<new_page_name>"

    When I reload the application
    And I expand the parent for the tree node "<parent_path>"
    Then I should see the page titled "<new_page_name>"

    When I click the tree node "<new_page_path>"
    Then I should have the following open tabs:
      | <new_page_name> |
    And I should see the application title "Rwiki <new_page_path>"
    And I should see "<new_page_name>" within "h1"
    And I should see a content for the page "<new_page_path>"

  Examples:
    | parent_path                             | new_page_name   | new_page_path                               |
    | /Home                                   | Hello World!    | /Home/Hello World!                          |
    | /Home/About                             | About something | /Home/About/About something                 |
    | /Home/Personal stuff                    | The new page    | /Home/Personal stuff/The new page           |
    | /Home/Development/Databases             | MongoDB         | /Home/Development/Databases/MongoDB         |
    | /Home/Development/Programming Languages | PHP             | /Home/Development/Programming Languages/PHP |

  Scenario Outline: Create an existing page
    When I right click the tree node "<parent_path>"
    And I follow "Add page"
    Then I should see dialog box titled "Add page"

    When I fill in the input with "<new_page_name>" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the page titled "<new_page_name>"

    When I reload the application
    And I expand the parent for the tree node "<parent_path>"
    Then I should see the page titled "<new_page_name>"

    When I click the tree node "<parent_path>/<new_page_name>"
    And I wait for load the page
    Then I should see a content for the page "<parent_path>/<new_page_name>"

  Examples:
    | parent_path                             | new_page_name |
    | /Home                                   | About         |
    | /Home/Personal stuff                    | Addresses     |
    | /Home/Development/Programming Languages | Java          |
    | /Home/Development/Programming Languages | JavaScript    |
    | /Home/Development/Programming Languages | Python        |
    | /Home/Development/Programming Languages | Ruby          |
