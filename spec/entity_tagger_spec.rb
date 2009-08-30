require File.join(File.dirname(__FILE__), "/../lib/entity_tagger")
require File.join(File.dirname(__FILE__), "/../lib/css_class_annotation_formatter")

describe EntityTagger do
  
  before(:all) do
    # Do this only once for all examples, because loading the models is expensive
    @tagger = EntityTagger.new(CSSClassAnnotationFormatter.new)
  end
  
  it "should tag a sentence" do
    text = "Mrs. Schmidt went to Copenhagen."
    result = @tagger.tag(text)
    result.should == "Mrs. <span class=\"person\">Schmidt</span> went to <span class=\"location\">Copenhagen</span>."
  end
  
  it "should sort the tags correctly" do
    text = "Yesterday was Jack's birthday."
    result = @tagger.tag(text)
    result.should == "<span class=\"date\">Yesterday</span> was <span class=\"person\">Jack</span>'s birthday."
  end

  it "should deal with overlapping tags" do
    text = "The Reagan Foundation"
    @tagger.tag(text).should == "The <span class=\"organization\"><span class=\"person\">Reagan</span> Foundation</span>"
  end

  it "should remove conflicts"
  
end