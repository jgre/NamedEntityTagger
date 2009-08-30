require File.join(File.dirname(__FILE__), "/../lib/css_class_annotation_formatter")

describe CSSClassAnnotationFormatter do
  
  it "should insert <span> tags with a class corresponding to the tag of the annotation around the annotated text" do
    ann = mock("annotation")
    text = "This is a test."
    span = Range.new(5, 9)
    # span.stub(:getStart).and_return(5)
    #     span.stub(:getEnd).and_return(9)
    ann.stub(:span).and_return(span)
    ann.stub(:tag).and_return("bogus")
    
    formatter = CSSClassAnnotationFormatter.new
    result = formatter.apply_annotations(text, [ann])
    result.should == "This <span class=\"bogus\">is a</span> test."
  end
  
  it "should deal with annotation spans included in other spans" do
    text = "This is a test."
    ann1 = mock("annotation")
    ann2 = mock("annotation")
    ann1.stub(:span).and_return(Range.new(5, 7))
    ann2.stub(:span).and_return(Range.new(5, 9))    
    ann1.stub(:tag).and_return("bogus")
    ann2.stub(:tag).and_return("foobar")
    
    formatter = CSSClassAnnotationFormatter.new
    result = formatter.apply_annotations(text, [ann1, ann2])
    result.should == "This <span class=\"foobar\"><span class=\"bogus\">is</span> a</span> test."
  end
    
end