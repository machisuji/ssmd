require_relative 'processor'

module SSMD::Processors
  class MarkProcessor < Processor
    def result
      "<mark name=\"#{text}\"/>"
    end

    def regex
      /@(\w+)/
    end
  end
end
