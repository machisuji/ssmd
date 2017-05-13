require 'ssmd/annotation_processor'
require 'ssmd/emphasis_processor'
require 'ssmd/mark_processor'

class Converter
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def convert
    result = processors.inject(input) do |text, processor|
      process processor.new, text
    end

    "<speak>#{result.strip}</speak>"
  end

  def processors
    [
      EmphasisProcessor, MarkProcessor, AnnotationProcessor
    ]
  end

  def process(processor, input)
    if processor.matches? input
      process processor, processor.substitute(input)
    else
      input
    end
  end

  def output
    "<speak>#{input.strip}</speak>"
  end
end
