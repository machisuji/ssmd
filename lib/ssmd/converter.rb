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

  def explicit_annotation

  end

  def output
    "<speak>#{input.strip}</speak>"
  end
end

class AnnotationProcessor
  attr_reader :input

  def initialize(input)
    @input = input
  end

  ##
  # Matches explicitly annotated sections.
  # For example:
  #
  #     [Guardians of the Galaxy](en-GB, v: +4dB, p: -3%)
  def self.regex
    %r{
      \A
      \[                              # opening text
        ([^\]]+)                      # annotated text
      \]                              # closing text
      \(                              # opening annotations
        ((?:
          (?:
            (?:#{language_regex})  # language annotation
          )(?:,\s?)?
        )+)
      \)                              # closing annotations
      \Z
    }x
  end

  def self.language_regex
    /[a-z]{2}(?:-[A-Z]{2})?/
  end
end
