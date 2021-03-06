Feature: Delete a page

  Background:
    Given I open the application

  Scenario: Delete a page
    When I right click the tree node "/Home/Personal stuff"
    And I follow "Delete page"
    Then I should see dialog box titled "Confirm"

    When I press "Yes" within the dialog box
    Then I should not see the tree node titled "Personal stuff"

    When I reload the application
    Then I should not see the tree node titled "Personal stuff"

  Scenario: Delete a page when the tab is open
    When I open the page "/Home/Personal stuff"
    And I open the page "/Home/Development"
    And I right click the tree node "/Home/Development"
    And I follow "Delete page"
    Then I should see dialog box titled "Confirm"

    When I press "Yes" within the dialog box
    Then I should not see the tree node titled "Development"
    And I should see active tab titled "Personal stuff"
    And I should see the application title "Rwiki /Home/Personal stuff"

    When I right click the tree node "/Home/Personal stuff"
    And I follow "Delete page"
    Then I should see dialog box titled "Confirm"

    When I press "Yes" within the dialog box
    Then I should not see the tree node titled "Personal stuff"
    And I should have no open tabs
    And I should see the application title "Rwiki"
