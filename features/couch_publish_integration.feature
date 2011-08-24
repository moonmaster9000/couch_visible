Feature: Integration with CouchPublish
  Whenever I include CouchVisible into a model that already includes CouchPublish
  Then I should be able to qualify my "(map|count)_by_(shown|hidden)" query proxies with "published" and "unpublished" modifiers

  Scenario: Getting all published, shown documents
    Given a model that includes CouchPublish and CouchVisible:
      """
        class Query < CouchRest::Model::Base
          include CouchPublish
          include CouchVisible
        end
      """

    And two documents that are shown but not published:
      """
        @shown_unpublished = [
          Query.create.tap {|q| q.show!; q.save}, 
          Query.create.tap {|q| q.show!; q.save}
        ]
      """

    And three documents that are shown and published:
      """
        @shown_published = [
          Query.create.tap {|q| q.show!; q.publish!}, 
          Query.create.tap {|q| q.show!; q.publish!},
          Query.create.tap {|q| q.show!; q.publish!},
        ]
      """

    Then "Query.map_by_shown.published.get!" should return the shown, published documents:
      """
        Query.map_by_shown.published.get!.collect(&:id).sort.should == @shown_published.collect(&:id).sort
      """

    Then "Query.map_by_shown.unpublished.get!" should return the shown, unpublished documents:
      """
        Query.map_by_shown.unpublished.get!.collect(&:id).sort.should == @shown_unpublished.collect(&:id).sort
      """
