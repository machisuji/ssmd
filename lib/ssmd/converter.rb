class Converter
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def convert
    self
      .emphasis
      .mark
      .output
  end

  def emphasis
    Converter.new input.gsub(/\*([^\*]+)\*/, '<emphasis>\1</emphasis>')
  end

  def mark
    Converter.new input.gsub(/@(\w+)/, '<mark name="\1"/>')
  end

  def output
    "<speak>#{input.strip}</speak>"
  end
end