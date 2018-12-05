require 'ssmd/processors'
require 'cgi'

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
      result = processors.inject(escape_xml(input)) do |text, processor|
        process processor.new(processor_options), text
      end

      "<speak>#{result.strip}</speak>"
    end

    def strip
      result = processors.inject(escape_xml(input)) do |text, processor|
        process processor.new(processor_options), text, strip: true
      end

      unescape_xml result
    end

    def processors
      @processors ||= begin
        p = SSMD::Processors

        [
          p::EmphasisProcessor, p::AnnotationProcessor, p::MarkProcessor,
          p::ProsodyProcessor, p::ParagraphProcessor, p::BreakProcessor
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

    ##
    # Substitutes special characters with their XML entity.
    # E.g. it substitutes "<" with "&lt;".
    def escape_xml(text)
      text.encode(xml: :text)
    end

    ##
    # Substitutes back XML entities with their plain text equivalent.
    # E.g. it substitutes "&lt;" with "<".
    #
    # @TODO Find alternative which applies to XML in general.
    # Not sure if it even makes a difference in this case, though.
    def unescape_xml(text)
      CGI.unescape_html text
    end
  end
end
