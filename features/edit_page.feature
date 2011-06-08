Feature: Editing the page

  Background:
    Given I open the application

  Scenario Outline: Invoke the editor window
    When I open the page "<path>"
    And I press "Edit page"
    Then I should see the window titled "Editing page <path>"

  Examples:
    | path                                         |
    | /Home                                        |
    | /Home/About                                  |
    | /Home/Personal stuff/Addresses               |
    | /Home/Development/Programming Languages/Ruby |
    | /Home/Development/Programming Languages/Java |


  Scenario Outline: Edit and save the page
    When I open the page "<path>"
    And I press "Edit page"
    Then I should see the window titled "Editing page <path>"

    When I fill in "editor" with "h1. <content>"
    And I press "Save"
    Then I should not see the window

    When I wait for load the page
    Then I should see "<content>" within "h1"
    And I should see a content for the page "<path>"

    When I reload the application
    Then I should see "<content>" within "h1"
    And I should see a content for the page "<path>"

  Examples:
    | path                                         | content           |
    | /Home                                        | A new page header |
    | /Home/About                                  | A new About page  |
    | /Home/Personal stuff/Addresses               | Moje adresy       |
    | /Home/Development/Programming Languages/Ruby | Ruby is awesome   |
    | /Home/Development/Programming Languages/Java | Java sux          |


  Scenario Outline: Edit and Save and continue
    When I open the page "<path>"
    And I press "Edit page"
    Then I should see the window titled "Editing page <path>"

    When I fill in "editor" with "h1. <content>"
    And I press "Save and continue"
    And I wait for load the page
    Then I should see the window titled "Editing page <path>"
    And I should see a content for the page "<path>"
    And I should see "<content>" within "h1"

  Examples:
    | path                                         | content                                  |
    | /Home                                        | This is Rwiki Home Page                  |
    | /Home/About                                  | This is a sample page, zażółć gęsią jaźń |
    | /Home/Personal stuff/Addresses               | Moje adresy                              |
    | /Home/Development/Programming Languages/Ruby | Ruby is awesome                          |
    | /Home/Development/Programming Languages/Java | Java sux                                 |

  Scenario: Edit and Cancel
    When I open the page "/Home"
    And I press "Edit page"
    Then I should see the window titled "Editing page /Home"

    When I fill in "editor" with "h1. A new page header"
    And I press "Cancel"
    Then I should see a content for the page "/Home"
    And I should see "This is Rwiki Home Page" within "h1"
