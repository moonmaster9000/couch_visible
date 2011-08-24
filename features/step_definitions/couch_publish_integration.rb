Given /^a model that includes .*:$/ do |string|
  eval string
end

Given /^.*documents that are .*:$/ do |string|
  eval string
end

Then /^.* should return.*:$/ do |string|
  eval string
end
