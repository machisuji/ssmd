require 'ssmd/processor'
require 'ssmd/language_annotation'

class AnnotationProcessor < Processor
  attr_reader :text, :annotations

  def result
    @text, annotations_text = match.captures

    if annotations_text
      @annotations = combine_annotations parse_annotations(annotations_text)

      @annotations.inject(text) do |text, a|
        a.wrap(text)
      end
    end
  end

  def self.annotations
    [LanguageAnnotation]
  end

  def ok?
    !@text.nil? && Array(@annotations).size > 0
  end

  def error?
    !ok?
  end

  private

  def parse_annotations(text)
    text.split(/, ?/).flat_map do |annotation_text|
      annotation = find_annotation annotation_text

      if annotation.nil?
        @warnings.push "Unknown annotation: #{text}"
      end

      [annotation].compact
    end
  end

  def find_annotation(text)
    self.class.annotations.lazy
      .map { |a| a.try text }
      .find { |a| !a.nil? }
  end

  def combine_annotations(annotations)
    annotations
      .group_by { |a| a.class }
      .values
      .map { |as| as.reduce { |a, b| a.combine b } }
  end

  ##
  # Matches explicitly annotated sections.
  # For example:
  #
  #     [Guardians of the Galaxy](en-GB, v: +4dB, p: -3%)
  def regex
    %r{
      \[                              # opening text
        ([^\]]+)                      # annotated text
      \]                              # closing text
      \(                              # opening annotations
        ((?:
          (?:
            #{annotations_regex}
          )(?:,\s?)?
        )+)
      \)                              # closing annotations
    }x
  end

  def annotations_regex
    self.class.annotations.map(&:regex).join("|")
  end
end