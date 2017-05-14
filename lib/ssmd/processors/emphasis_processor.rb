require_relative 'processor'

module SSMD::Processors
  class EmphasisProcessor < Processor
    def result
      "<emphasis>#{text}</emphasis>"
    end

    def regex
      /\*([^\*]+)\*/
    end
  end
end
