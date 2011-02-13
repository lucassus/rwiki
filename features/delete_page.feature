Feature: Delete a page

  Background:
    Given I open the application

  Scenario: Delete a page
    When I right click the node with path "/Home/Personal stuff"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"

    When I press "Yes" within the dialog box
    Then I should not see the node titled "Personal stuff"

    When I reload the application
    Then I should not see the node titled "Personal stuff"

  Scenario: Delete a page when a tab is open
    When I open the page for the tree node with path "/Home/Personal stuff"
    And I open the page for the tree node with path "/Home/Development"
    And I right click the node with path "/Home/Development"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"

    When I press "Yes" within the dialog box
    Then I should not see the node titled "Development"
    And I should see active tab titled "Personal stuff"
    And I should see page title "Rwiki /Home/Personal stuff"

    When I right click the node with path "/Home/Personal stuff"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"

    When I press "Yes" within the dialog box
    Then I should not see the node titled "Personal stuff"
    And I should have no open tabs
    And I should see page title "Rwiki"
