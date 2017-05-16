require 'ssmd/processors'

module SSMD
  class Converter
    attr_reader :input

    def initialize(input, skip: [])
      @input = input

      processors.delete_if do |processor|
        Array(skip).any? { |name| processor.name =~ /\ASSMD::Processors::#{name}Processor\Z/i }
      end
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
      @processors ||= begin
        p = SSMD::Processors

        [
          p::EmphasisProcessor, p::AnnotationProcessor, p::MarkProcessor,
          p::ProsodyProcessor, p::ParagraphProcessor
        ]
      end
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
