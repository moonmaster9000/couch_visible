Then /^the document should be marked as shown$/ do
  @document.shown?.should be(true)
  @document.visible.should be(true)
end

Given /^a document that is not shown$/ do
  class HiddenDoc < CouchRest::Model::Base
    include CouchVisible
  end

  @document = HiddenDoc.new.tap {|d| d.hide! and d.save }
end

When /^I call the "by_shown" method$/ do
  @result = TestDoc.by_shown :reduce => false
end

Then /^I should receive the shown documents$/ do
  @result.collect(&:id).sort.should == @shown_documents.collect(&:id).sort
end

Then /^I should not receive the hidden documents$/ do
  @result_ids = @result.collect &:id
  @hidden_documents.collect(&:id).each do |hidden_id| 
    @result_ids.include?(hidden_id).should be(false)
  end

end

When /^I call the "count_shown" method on my document model$/ do
  @result = TestDoc.count_shown
end

Then /^I should receive the count of shown documents$/ do
  @result.should == @shown_documents.count
end
