Feature: Delete a page

  Background:
    Given I open the application

  Scenario: Delete a page
    When I right click the node with path "/Home"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"

    When I press "Yes" within the dialog box
    Then I should not see the node titled "Home"

    When I reload the application
    Then I should not see the node titled "Home"

  Scenario: Delete a page when a tab is open
    When I open the page for the tree node with path "/Home"
    And I open the page for the tree node with path "/Home/Development/Programming Languages/Ruby"
    And I right click the node with path "/Home"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"

    When I press "Yes" within the dialog box
    Then I should not see the node titled "Home"
    And I should see active tab titled "ruby"
    And I should see page title "Rwiki /Home/Development/Programming Languages/Ruby"

    When I right click the node with path "/Home/Development/Programming Languages/Ruby"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"

    When I press "Yes" within the dialog box
    Then I should not see the node titled "Ruby"
    And I should have no open tabs
    And I should see page title "Rwiki"
