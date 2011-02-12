Feature: Create page

  Background:
    Given I open the application

  Scenario: Create a new page
    When I right click the node with path "/Home/Personal stuff"
    And I follow "Create page"
    Then I should see dialog box titled "Create page"

    When I fill in the input with "The new page" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the node titled "The new page"

    When I reload the application
    And I expand the node with path "/Home/Personal stuff"
    Then I should see the node titled "The new page"

    When I click the node with path "/Home/Personal stuff/The new page.txt"
    Then I should have the following open tabs:
      | The new page |
    And I should see page title "Rwiki /Home/Personal stuff/The new page.txt"
    And I should see "The new page" within "h1"
    And I should see generated content for the node with path "/Home/Personal stuff/The new page.txt"

  Scenario: Create an existing page
    When I right click the node with path "/Home/Personal stuff"
    And I follow "Create page"
    Then I should see dialog box titled "Create page"

    When I fill in the input with "test" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the node titled "test"

    When I reload the application
    And I expand the node with path "/Home/Personal stuff"
    Then I should see the node titled "test"

    When I click the node with path "/Home/Personal stuff/Addresses"
    Then I should see generated content for the node with path "/Home/Personal stuff/Addresses"

  Scenario: Create a folder
    When I right click the node with path "/Home/Personal stuff"
    And I follow "Create folder"
    Then I should see dialog box titled "Create folder"

    When I fill in the input with "The new folder" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the node titled "The new folder"

    When I reload the application
    And I expand the node with path "/Home/Personal stuff"
    Then I should see the node titled "The new folder"
