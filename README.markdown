# Named Entity Tagger #

A Ruby library for tagging named entities in text based on
[OpenNPL](http://opennlp.sourceforge.net/). As OpenNLP is written in Java, NamedEntityTagger
needs to be run on [JRuby](http://jruby.org/).

## Dependencies ##

In order to use NamedEntityTagger, you need to download and build a few java libraries. The jar
files need to be placed in the deps directory. Furthermore, you need OpenNLP model data that
must be placed under models.

### Libraries ###

* [OpenNLP Tools](http://sourceforge.net/projects/opennlp/files/)
* [OpenNLP Maxent](http://sourceforge.net/projects/maxent/files/)
* [GNU Trove](http://opennlp.sourceforge.net/models/english/sentdetect/EnglishSD.bin.gz)

### Model Data ###

* [Sentence Detection](http://opennlp.sourceforge.net/models/english/sentdetect/EnglishSD.bin.gz)
* [Dates](http://opennlp.sourceforge.net/models/english/namefind/date.bin.gz)
* [Locations](http://opennlp.sourceforge.net/models/english/namefind/location.bin.gz)
* [Oranizations](http://opennlp.sourceforge.net/models/english/namefind/organization.bin.gz)
* [Persons](http://opennlp.sourceforge.net/models/english/namefind/person.bin.gz)

## Usage ##

NamedEntityTagger exposes a minimal API. The main class is `EntityTagger` and it provides the
method `#tag(text)`. This method takes the text that should be tagged and returns a new string
where the words that were identified as named entities are highlighted. The encoding of the
output is defined by a formatter object. Currently there is only the
CSSClassAnnotationFormatter that adds span tags around the named entities. The span tag has a
class corresponding to the model that matched the entity.

For example:

    require 'lib/entity_tagger'
    require 'lib/css_class_annotation_formatter' 
    tagger = EntityTagger.new(CSSClassAnnotationFormatter.new)
    tagger.tag("Mrs. Smith flew to Berlin")

    => "Mrs. <span class=\"person\">Smith</span> flew to <span class=\"location\">Berlin</span>"
