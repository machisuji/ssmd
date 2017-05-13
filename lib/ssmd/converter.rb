require 'ssmd/processors'

module SSMD
  class Converter
    attr_reader :input

    def initialize(input)
      @input = input
    end

    def convert
      result = processors.inject(input) do |text, processor|
        process processor.new, text
      end

      "<speak>#{result.strip}</speak>"
    end

    def processors
      p = SSMD::Processors

      [
        p::EmphasisProcessor, p::MarkProcessor, p::AnnotationProcessor
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
