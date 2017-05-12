require 'ssmd/annotation'

class LanguageAnnotation < Annotation
  attr_reader :language

  def self.regex
    /([a-z]{2}(?:-[A-Z]{2})?)/
  end

  def initialize(language)
    @language = complete_language language
  end

  def wrap(text)
    "<lang xml:lang=\"#{language}\">#{text}</lang>"
  end

  def combine(annotation)
    self # discard further language annotations
  end

  def complete_language(language)
    if language.size == 2
      language_completion_table[language] || "#{language}-#{language.upcase}"
    else
      language
    end
  end

  def language_completion_table
    {
      "en" => "en-US"
    }
  end
end