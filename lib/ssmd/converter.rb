require 'ssmd/processors'

module SSMD
  class Converter
    attr_reader :input, :skip

    def initialize(input, skip: [])
      @input = input
      @skip = Array(skip)

      processors.delete_if do |processor|
        self.skip.any? { |name| processor.name =~ /\ASSMD::Processors::#{name}Processor\Z/i }
      end
    end

    def convert
      result = processors.inject(input.encode(xml: :text)) do |text, processor|
        process processor.new(processor_options), text
      end

      "<speak>#{result.strip}</speak>"
    end

    def strip
      processors.inject(input) do |text, processor|
        process processor.new(processor_options), text, strip: true
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

    def processor_options
      { skip: skip }
    end
  end
end
