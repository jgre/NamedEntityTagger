Struct.new("InsertionTag", :position, :tag)

class CSSClassAnnotationFormatter
  
  def apply_annotations(text, annotations)
    annotations.sort! do |ann1, ann2|
      # Sort based on the span's start index ascending then end index descending
      if ann1.span.begin == ann2.span.begin
        ann2.span.end <=> ann1.span.end
      else
        ann1.span.begin <=> ann2.span.begin
      end
    end
    insertion_tags = annotations.inject([]) do |memo, ann|
      memo << Struct::InsertionTag.new(ann.span.begin, "<span class=\"#{ann.tag}\">")
      memo << Struct::InsertionTag.new(ann.span.end, "</span>")
      memo
    end
    insertion_tags = insertion_tags.sort_by {|tag| tag.position}

    result = text.clone
    offset = 0
    insertion_tags.each do |tag|
      result.insert(tag.position + offset, tag.tag)
      offset += tag.tag.length
    end
    result
  end

end