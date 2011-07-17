Given /^I have a model that includes Memories$/ do
  class VersionedModel < CouchRest::Model::Base
    include Memories
  end
end

When /^I mix CouchVisible into that model$/ do
  VersionedModel.send :include, CouchVisible
end

Then /^the "([^"]*)" property should not be versioned$/ do |property|
  VersionedModel.forget_properties.include?(property).should be(true)
end
