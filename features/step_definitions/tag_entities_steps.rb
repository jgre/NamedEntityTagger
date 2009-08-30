Given /^the text "(.*)"$/ do |txt|
  @text = txt
end

When /^tagging is requested$/ do
  tagger = EntityTagger.new(CSSClassAnnotationFormatter.new)
  @result = tagger.tag @text
end

Then /^I should get "(.*)"$/ do |txt|
  @result.should == txt
end