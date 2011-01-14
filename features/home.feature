Feature: view pages

  @javascript
  Scenario: Home page
    Given I go to the home page
    Then I should see "Rwiki"
