Feature: Tab Panel

  Background:
    Given I open the application

  Scenario: Close a tab
    When I open the page for the tree node with path "/Home"
    And I open the page for the tree node with path "/Home/About"

    Then I should have the following open tabs:
      | Home  |
      | About |
    And the node with path "/Home/About" should be selected

    When I close tab for page "/Home/About"
    Then I should have the following open tabs:
      | About |
    And the node with path "/Home/About" should be selected

    When I close tab for page "/Home"
    Then I should have no open tabs

  Scenario: Switching the tabs
    When I open the page for the tree node with path "/Home"
    And I open the page for the tree node with path "/Home/About"
    Then I should see "This is a test"

    When I click tab for page "/Home"
    Then I should see "Sample page" within "h1"
    And the node with path "/Home" should be selected
    And the node with path "/Home/About" should not be selected

    When I click tab for page "/Home/About"
    Then I should see "This is a test"
    And the node with path "/Home/About" should be selected
    And the node with path "/Home" should not be selected
