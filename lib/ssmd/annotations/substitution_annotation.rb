require_relative 'annotation'

require 'pathname'

module SSMD::Annotations
  class SubstitutionAnnotation < Annotation
    attr_reader :text_alias

    def self.regex
      /sub: ?(.+)/
    end

    def initialize(text_alias)
      @text_alias = text_alias
    end

    def wrap(text)
      "<sub alias=\"#{text_alias}\">#{text}</sub>"
    end

    def combine(annotation)
      self # discard further substitution annotations
    end
  end
end
