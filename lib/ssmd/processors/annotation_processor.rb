require_relative 'processor'

require 'ssmd/annotations'

module SSMD::Processors
  class AnnotationProcessor < Processor
    attr_reader :annotations

    def initialize(options = {})
      super

      @annotations = self.class.annotations.dup

      annotations.delete_if do |annotation|
        Array(options[:skip]).any? { |name| annotation.name =~ /\ASSMD::Annotations::#{name}Annotation\Z/i }
      end
    end

    def result
      _, annotations_text = match.captures

      if annotations_text
        @annotations = combine_annotations parse_annotations(annotations_text)

        @annotations.inject(text) do |text, a|
          a.wrap(text)
        end
      end
    end

    def self.annotations
      a = SSMD::Annotations

      [
        a::LanguageAnnotation, a::PhonemeAnnotation, a::ProsodyAnnotation,
        a::SubstitutionAnnotation
      ]
        .freeze
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
          warnings.push "Unknown annotation: #{text}"
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
      @regex ||= %r{
        \[                              # opening text
          ([^\]]+)                      # annotated text
        \]                              # closing text
        \(                              # opening annotations
          ((?:
            (?:
              #{annotations_regex}      # annotations
            )(?:,\s?)?
          )+)
        \)                              # closing annotations
      }x
    end

    def annotations_regex
      annotations.map(&:regex).join("|")
    end

    def warnings
      @warnings ||= []
    end
  end
end
