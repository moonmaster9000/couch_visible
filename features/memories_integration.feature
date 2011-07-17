Feature: Integration with the Memories gem
  As a programmer
  I want the couch_visible gem to integrate with the memories gem
  So that the visibility of my documents isn't versioned

  Scenario: mixing CouchVisible into an object that already includes Memories
    Given I have a model that includes Memories
    When I mix CouchVisible into that model
    Then the "couch_visible" property should not be versioned
