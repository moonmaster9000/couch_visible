Given /^I have edited the global configuration$/ do
  CouchVisible.show_by_default?.should be(false)
  CouchVisible.show_by_default!
  CouchVisible.show_by_default?.should be(true)
end

When /^I run the following code:$/ do |string|
  @result = eval string
end

Then /^the configuration of the CouchVisible gem should be reset to its defaults$/ do
  CouchVisible.show_by_default?.should be(false)
end

Then /^I should get false$/ do
  @result.should == false
end

Then /^any documents I create should be visible by default$/ do
  Document.create.shown?.should be(true)
  Document.create.hidden?.should be(false)
end

Then /^any documents I create should be hidden by default$/ do
  Document.create.hidden?.should be(true)
  Document.create.shown?.should be(false)
end

Given /^a model that includes CouchVisible$/ do
  class MyModel < CouchRest::Model::Base
    include CouchVisible
  end
end

When /^I create an instance of my model$/ do
  @instance = MyModel.create
end

Then /^it should be hidden$/ do
  @instance.hidden?.should be(true)
end

Given /^I set the global configuration of CouchVisible to shown by default$/ do
  CouchVisible.show_by_default!
end

Then /^it should be shown$/ do
  @instance.shown?.should be(true)
end

When /^I call "([^"]*)" on it$/ do |method|
  MyModel.send method
end

Then /^I should get true$/ do
  @result.should be(true)
end
