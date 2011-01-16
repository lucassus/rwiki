Feature: Delete a page

  Background:
    Given I go to the home page
    And I wait for ajax call complete


  @javascript
  Scenario: Delete a page
    When I right click node "./home.txt"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"

    When I press "Yes"
    And I reload the page
    Then I should not see "home"

  @javascript
  Scenario: Delete a page when tab is open
    When I click node "./home.txt"
    And I click node "./test.txt"
    And I right click node "./home.txt"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"

    When I press "Yes"
    Then I should have the following open tabs:
      | test |


    When I right click node "./test.txt"
    And I follow "Delete node"
    Then I should see dialog box titled "Confirm"
    When I press "Yes"
    Then I should have no open tabs
    