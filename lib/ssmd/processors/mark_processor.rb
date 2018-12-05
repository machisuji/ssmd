require_relative 'processor'
require_relative 'concerns/no_content'

module SSMD::Processors
  class MarkProcessor < Processor
    prepend NoContent

    def result
      name = match.captures.first

      "<mark name=\"#{name}\"/>"
    end

    def text
      ""
    end

    def regex
      /@(\w+)/
    end
  end
end
