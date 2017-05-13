require_relative 'processor'

module SSMD::Processors
  class EmphasisProcessor < Processor
    def result
      text = match.captures.first

      "<emphasis>#{text}</emphasis>"
    end

    def regex
      /\*([^\*]+)\*/
    end
  end
end
