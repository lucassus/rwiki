Feature: Tab Panel

  Background:
    Given I open the application

  Scenario: Close a tab
    When I open the page "/Home"
    And I open the page "/Home/About"

    Then I should have the following open tabs:
      | Home  |
      | About |
    And the tree node "/Home/About" should be selected

    When I close a tab for node "/Home/About"
    Then I should have the following open tabs:
      | Home |
    And the tree node "/Home/About" should be selected

    When I close a tab for node "/Home"
    Then I should have no open tabs

  Scenario: Switching the tabs
    When I open the page "/Home"
    And I open the page "/Home/About"

    When I click a tab for page "/Home"
    And the tree node "/Home" should be selected
    And the tree node "/Home/About" should not be selected

    When I click a tab for page "/Home/About"
    And the tree node "/Home/About" should be selected
    And the tree node "/Home" should not be selected
