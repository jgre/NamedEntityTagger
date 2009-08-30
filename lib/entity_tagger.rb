require 'java'
require File.join(File.dirname(__FILE__), '../deps/opennlp-tools-1.4.3.jar')
require File.join(File.dirname(__FILE__), '../deps/maxent-2.5.2.jar')
require File.join(File.dirname(__FILE__), '../deps/trove-2.1.0.jar')

java_import Java::opennlp.tools.namefind.NameFinderME
java_import Java::opennlp.tools.tokenize.SimpleTokenizer
java_import Java::opennlp.maxent.io.BinaryGISModelReader
java_import Java::opennlp.tools.lang.english.SentenceDetector
java_import Java::opennlp.tools.util.Span

Struct.new("Annotation", :tag, :span)

class EntityTagger
  
  def initialize(formatter)
    @formatter = formatter
    @detector = SentenceDetector.new(File.expand_path("models/EnglishSD.bin.gz"))
    @finders = %w{person location date organization}.map do |model|
      [model, NameFinderME.new(BinaryGISModelReader.new(java.io.File.new("models/#{model}.bin.gz")).getModel)]
    end
    @tokenizer = SimpleTokenizer.new
  end

  def tag(text)
    sentences = @detector.sentDetect(text)
    # We the the start positions of the sentences to compute the offsets of
    # tokens in respect to the whole text. Detector#sentPosDetect returns the
    # positions where a new sentece starts, so we add position 0 to the list.
    sentence_positions = [0] + @detector.sentPosDetect(text)
    annotations = []
    
    sentences.each_with_index do |sentence, sentence_idx|
      # We need the token positions for annotating the text
      token_positions = @tokenizer.tokenizePos(sentence)
      # We need the tokens as strings to find the matching classes using OpenNLP
      tokens = Span.spansToStrings(token_positions, sentence)
      @finders.each do |model, finder|
        names = finder.find(tokens)
        annotations += names.map do |name|
          start_pos = token_positions[name.getStart].getStart + sentence_positions[sentence_idx]
          end_pos = token_positions[name.getEnd-1].getEnd + sentence_positions[sentence_idx]
          Struct::Annotation.new(model, Range.new(start_pos, end_pos))
        end

        # names.each do |name|
        #           puts "#{model}: #{tokens[name.getStart..name.getEnd - 1].to_a.join(" ")} (#{finder.probs([name].to_java(Span)).to_a.join(", ")})"
        #         end
      end
    end
    @formatter.apply_annotations(text, annotations)
  end
    
end
