Feature: Rename a node

  Background:
    Given I open the application

  Scenario: Rename a page
    When I right click the tree node "/Home/About"
    And I follow "Rename page"
    Then I should see dialog box titled "Rename page"

    When I fill in the input with "The new About" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the page titled "The new About"

    When I reload the application
    Then I should see the page titled "The new About"

    When I click the tree node "/Home/The new About"
    And I should see a content for the page "/Home/The new About"

  Scenario: Rename a page to existing name
    When I right click the tree node "/Home/About"
    And I follow "Rename page"
    Then I should see dialog box titled "Rename page"

    When I fill in the input with "Personal stuff" within the dialog box
    And I press "OK" within the dialog box
    And I reload the application
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

  Scenario: Rename a page when tab is open
    When I click the tree node "/Home/About"
    And I click the tree node "/Home"
    Then I should see the application title "Rwiki /Home"

    And I right click the tree node "/Home/About"
    And I follow "Rename page"
    Then I should see dialog box titled "Rename page"

    When I fill in the input with "The new About" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the page titled "The new About"
    And I should have the following open tabs:
      | The new About |
      | Home          |
    And I should see the application title "Rwiki /Home/The new About"
    And I should see a content for the page "/Home/The new About"
