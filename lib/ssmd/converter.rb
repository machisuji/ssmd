require 'ssmd/annotation_processor'

class Converter
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def convert
    self
      .emphasis
      .mark
      .annotations
      .output
  end

  def emphasis
    Converter.new input.gsub(/\*([^\*]+)\*/, '<emphasis>\1</emphasis>')
  end

  def mark
    Converter.new input.gsub(/@(\w+)/, '<mark name="\1"/>')
  end

  def annotations
    process AnnotationProcessor.new, input
  end

  def process(processor, input)
    if processor.matches? input
      process processor, processor.substitute(input)
    else
      Converter.new input
    end
  end

  def output
    "<speak>#{input.strip}</speak>"
  end
end
