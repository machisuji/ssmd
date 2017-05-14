require 'ssmd/processors'
require 'rexml/document'

module SSMD
  class Converter
    attr_reader :input

    def initialize(input)
      @input = input
    end

    def convert
      result = processors.inject(input.encode(xml: :text)) do |text, processor|
        process processor.new, text
      end

      "<speak>#{result.strip}</speak>"
    end

    def strip
      doc = ::REXML::Document.new input

      if doc.root
        xml_text doc.root
      else
        input # no XML so we assume it is already stripped
      end
    end

    def xml_text(node)
      if node.is_a? REXML::Text
        node.to_s
      else
        node.children.map { |c| xml_text c }.join
      end
    end

    def processors
      p = SSMD::Processors

      [
        p::EmphasisProcessor, p::AnnotationProcessor, p::MarkProcessor
      ]
    end

    def process(processor, input)
      if processor.matches? input
        process processor, processor.substitute(input)
      else
        input
      end
    end
  end
end
