Feature: Configuration
  As a programmer
  I want to specify whether or not a model's documents are shown or hidden by default
  So that I can configure the functionality of this gem for my own evil purposes
  
  Scenario: Resetting the configuration
    Given I have edited the global configuration
    When I run the following code: 
      """
        CouchVisible.reset!
      """
    Then the configuration of the CouchVisible gem should be reset to its defaults

  Scenario: The "visible_by_default" global setting should default to false
    When I run the following code: 
      """
        CouchVisible.visible_by_default?
      """
    Then I should get false
    When I run the following code:
      """
        CouchVisible.visible_by_default!
      """
    And I run the following code:
      """
        CouchVisible.visible_by_default?
      """
    Then I should get true

  Scenario: Globally setting the default visibility of documents
    When I run the following code:
      """
        CouchVisible.visible_by_default!
      """
    Then any documents I create should be visible by default
    When I run the following code:
      """
        CouchVisible.hidden_by_default!
      """
    Then any documents I create should be hidden by default

  Scenario: The visibility of documents should default to the global setting
    Given a model that includes CouchVisible
    When I create an instance of my model
    Then it should be hidden
    Given I set the global configuration of CouchVisible to shown by default
    When I create an instance of my model
    Then it should be shown
  
  Scenario: Setting the default visibility of documents on the model 
    Given a model that includes CouchVisible
    When I call "visible_by_default!" on it
    And I create an instance of my model
    Then it should be shown
    When I call "hidden_by_default!" on it
    And I create an instance of my model
    Then it should be hidden
