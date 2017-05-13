require_relative 'processor'

module SSMD::Processors
  class MarkProcessor < Processor
    def result
      text = match.captures.first

      "<mark name=\"#{text}\"/>"
    end

    def regex
      /@(\w+)/
    end
  end
end
