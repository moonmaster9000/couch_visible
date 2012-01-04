Feature: Showing a document
  As a programmer
  I want the ability to show a document
  So that I can flag a document as visible for viewing

  Scenario: Show a document
    Given an unsaved document that includes CouchVisible
    When I call the "show" method on the document
    Then the document should be marked as shown
    And the document should not be saved

  Scenario: Show a document and save it
    Given an unsaved document that includes CouchVisible
    When I call the "show!" method on the document
    Then the document should be marked as shown
    And the document should be saved

  Scenario: Determining if a document is shown
    Given a document that is not shown
    When I call the "shown?" method on the document
    Then I should get false
    When I call the "show!" method on the document
    And I call the "shown?" method on the document
    Then I should get true
    
  Scenario: Getting the list of all shown documents
    Given there are several hidden and visible documents
    When I call the "map_by_shown" method
    Then I should receive the shown documents
    And I should not receive the hidden documents

  @focus
  Scenario: Getting the count of all shown documents
    Given there are several hidden and visible documents
    When I call the "count_by_shown" method on my document model
    Then I should receive the count of shown documents
