Feature: Rename a node

  Background:
    Given I open the application

  Scenario: Rename a page
    When I right click the node with path "/Home/About"
    And I follow "Rename page"
    Then I should see dialog box titled "Rename page"

    When I fill in the input with "The New About" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the node titled "The new home"

    When I reload the application
    Then I should see the node titled "The new home"

    When I click the node with path "/Home/The New About"
    And I should see a content for the node with path "./The new home.txt"

  Scenario: Rename a page to existing name
    When I right click the node with path "/Home/About"
    And I follow "Rename page"
    Then I should see dialog box titled "Rename page"

    When I fill in the input with "Personal stuff" within the dialog box
    And I press "OK" within the dialog box
    And I reload the application
    And I should see "About"
    And I should see "Personal stuff"

    When I click the node with path "/Home"
    And I should see a content for the node with path "/Home"

    When I click the node with path "/Home/About"
    Then I should see a content for the node with path "/Home/About"
    And I should see the application title "Rwiki /Home/About"
    And I should have the following open tabs:
      | Home |
      | Test |

  Scenario: Rename a page when tab is open
    When I click the node with path "/Home/About"
    And I click the node with path "/Home"
    Then I should see the application title "Rwiki /Home"

    And I right click the node with path "/Home"
    And I follow "Rename page"
    Then I should see dialog box titled "Rename page"

    When I fill in the input with "The new home" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the node titled "The new home"
    And I should have the following open tabs:
      | test         |
      | The new home |
    And I should see the application title "Rwiki ./The new home.txt"
    And I should see a content for the node with path "./The new home.txt"
