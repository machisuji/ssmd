require 'ssmd/processors'

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
      processors.inject(input) do |text, processor|
        process processor.new, text, strip: true
      end
    end

    def processors
      p = SSMD::Processors

      [
        p::EmphasisProcessor, p::AnnotationProcessor, p::MarkProcessor,
        p::ProsodyProcessor
      ]
    end

    def process(processor, input, strip: false)
      if processor.matches? input
        result = strip ? processor.strip_ssmd(input) : processor.substitute(input)
        process processor, result, strip: strip
      else
        input
      end
    end
  end
end
