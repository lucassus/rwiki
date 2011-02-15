Feature: Create a new page

  Background:
    Given I open the application

  Scenario: Create a new page
    When I right click the tree node "/Home/Personal stuff"
    And I follow "Add page"
    Then I should see dialog box titled "Add page"

    When I fill in the input with "The new page" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the page titled "The new page"

    When I reload the application
    And I expand the tree node "/Home/Personal stuff"
    Then I should see the page titled "The new page"

    When I click the tree node "/Home/Personal stuff/The new page"
    Then I should have the following open tabs:
      | The new page |
    And I should see the application title "Rwiki /Home/Personal stuff/The new page"
    And I should see "The new page" within "h1"
    And I should see a content for the page  "/Home/Personal stuff/The new page"

  Scenario: Create an existing page
    When I right click the tree node "/Home/Personal stuff"
    And I follow "Add page"
    Then I should see dialog box titled "Add page"

    When I fill in the input with "test" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the page titled "test"

    When I reload the application
    And I expand the tree node "/Home/Personal stuff"
    Then I should see the page titled "test"

    When I click the tree node "/Home/Personal stuff/Addresses"
    Then I should see a content for the page  "/Home/Personal stuff/Addresses"
