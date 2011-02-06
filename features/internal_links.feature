Feature: Internal links

  Background:
    Given I open the application

  Scenario: Open tha page via internal link
    When I open the page for the tree node with path "./home.txt"
    And I follow "Ruby notes"
    Then I should see the page "./folder/subfolder/ruby.txt"
