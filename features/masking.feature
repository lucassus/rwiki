Feature: Masking on slow connection

  Background:
    Given I open the application
    And the connection is slow

  Scenario Outline: Mask on loading a page
    When I expand the parent for the tree node "<path>"
    And I click the tree node "<path>"
    Then I should see "Loading the Page..." within "div.x-masked"

  Examples:
    | path                                         |
    | /Home                                        |
    | /Home/About                                  |
    | /Home/Personal stuff/Addresses               |
    | /Home/Personal stuff/Notes                   |
    | /Home/Development/Programming Languages      |
    | /Home/Development/Programming Languages/Ruby |
    