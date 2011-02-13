Feature: Tab Panel

  Background:
    Given I open the application

  Scenario: Close a tab
    When I open the node with path "/Home"
    And I open the node with path "/Home/About"

    Then I should have the following open tabs:
      | Home  |
      | About |
    And the node with path "/Home/About" should be selected

    When I close a tab for node "/Home/About"
    Then I should have the following open tabs:
      | Home |
    And the node with path "/Home/About" should be selected

    When I close a tab for node "/Home"
    Then I should have no open tabs

  Scenario: Switching the tabs
    When I open the node with path "/Home"
    And I open the node with path "/Home/About"

    When I click a tab for node "/Home"
    And the node with path "/Home" should be selected
    And the node with path "/Home/About" should not be selected

    When I click a tab for node "/Home/About"
    And the node with path "/Home/About" should be selected
    And the node with path "/Home" should not be selected
