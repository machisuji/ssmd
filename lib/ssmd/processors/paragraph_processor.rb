require_relative 'processor'

module SSMD::Processors
  class ParagraphProcessor < Processor
    def result
      "<p>" + match.string.gsub(regex, "</p><p>") + "</p>"
    end

    def regex
      /\n\n+/
    end

    def substitute(input)
      result if match
    end

    def strip_ssmd(input)
      input.gsub(regex, "\n") if match
    end
  end
end
