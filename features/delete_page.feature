Feature: Delete a page

  Background:
    Given I open the application

  @javascript
  Scenario: Delete a page
    When I right click the node with path "./home.txt"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"

    When I press "Yes"
    Then I should not see the node titled "home"

    When I reload the application
    Then I should not see the node titled "home"

  @javascript
  Scenario: Delete a page when tab is open
    When I click the node with path "./home.txt"
    And I click the node with path "./test.txt"
    And I right click the node with path "./home.txt"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"

    When I press "Yes"
    Then I should not see the node titled "home"
    And I should have the following open tabs:
      | test |
    And I should see page title "Rwiki ./test.txt"

    When I right click the node with path "./test.txt"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"

    When I press "Yes"
    Then I should not see the node titled "test"
    And I should have no open tabs
    And I should see page title "Rwiki"
