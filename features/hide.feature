Feature: Hiding a document
  As a programmer
  I want the ability to hide a document
  So that I can flag a document as hidden
  
  Scenario: Hide a document
    Given a document that includes CouchVisible
    When I call the "hide!" method on the document
    Then the document should be marked as hidden

  Scenario: Determining if a document is hidden
    Given a document that is shown
    When I call the "hidden?" method on the document
    Then I should get false
    When I call the "hide!" method on the document
    And I call the "hidden?" method on the document
    Then I should get true

  Scenario: Getting the list of all hidden documents
    Given there are several hidden and visible documents
    When I call the "by_hidden" method on my document model
    Then I should receive the hidden documents
    And I should not receive the shown documents

  @focus
  Scenario: Getting the count of all hidden documents
    Given there are several hidden and visible documents
    When I call the "count_hidden" method on my document model
    Then I should receive the count of hidden documents
