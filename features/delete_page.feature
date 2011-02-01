Feature: Delete a page

  Background:
    Given I open the application

  Scenario: Delete a page
    When I right click the node with path "./home.txt"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"

    When I press "Yes" within the dialog box
    Then I should not see the node titled "home"

    When I reload the application
    Then I should not see the node titled "home"

  Scenario: Delete a page when a tab is open
    When I open the page for the tree node with path "./home.txt"
    And I open the page for the tree node with path "./folder/subfolder/ruby.txt"
    And I right click the node with path "./home.txt"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"

    When I press "Yes" within the dialog box
    Then I should not see the node titled "home"
    And I should see active tab titled "ruby"
    And I should see page title "Rwiki ./folder/subfolder/ruby.txt"

    When I right click the node with path "./folder/subfolder/ruby.txt"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"

    When I press "Yes" within the dialog box
    Then I should not see the node titled "ruby"
    And I should have no open tabs
    And I should see page title "Rwiki"
