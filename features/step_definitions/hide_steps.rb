Given /^a document that includes CouchVisible$/ do
  class Article < CouchRest::Model::Base
    include CouchVisible
  end

  @document = Article.create
end

Given /^an unsaved document that includes CouchVisible$/ do
  class Article < CouchRest::Model::Base
    include CouchVisible
  end

  @document = Article.new
end

When /^I call the "([^"]*)" method on the document$/ do |method|
  @result = @document.send method
end

Then /^the document should be marked as hidden$/ do
  @document.couch_visible.should be(false)
  @document.hidden?.should be(true)
end

Given /^a document that is shown$/ do
  class Post < CouchRest::Model::Base
    include CouchVisible
  end
  @document = Post.create 
  @document.show!
end

Given /^there are several hidden and visible documents$/ do
  class TestDoc < CouchRest::Model::Base
    include CouchVisible
  end

  @hidden_documents = [] 
  @shown_documents  = []
  10.times { @hidden_documents  << TestDoc.new.tap {|d| d.save }         }
  10.times { @shown_documents   << TestDoc.new.tap {|d| d.show!; d.save} }
end

When /^I call the "map_by_hidden" method on my document model$/ do 
  @result = TestDoc.map_by_hidden!
end

Then /^I should receive the hidden documents$/ do
  @result.collect(&:id).sort.should == @hidden_documents.collect(&:id).sort
end

Then /^I should not receive the shown documents$/ do
  @result_ids = @result.collect &:id
  @shown_documents.collect(&:id).each do |shown_id| 
    @result_ids.include?(shown_id).should be(false)
  end
end

When /^I call the "count_by_hidden" method on my document model$/ do
  @result = TestDoc.count_by_hidden.get!
end

Then /^the document should not be saved$/ do
  Article.all.should have(0).documents
end

Then /^the document should be saved$/ do
  Article.all.should have(1).document
end

Then /^I should receive the count of hidden documents$/ do
  @result.should == @hidden_documents.count
end
