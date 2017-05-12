class Annotation
  class << self
    def try(text)
      match = regex.match text

      if match
        new *match.captures
      end
    end

    def regex
      raise "subclass responsibility"
    end
  end

  def initialize
    raise "implement expecting one argumnt for each capture group in the regex"
  end

  def wrap(text)
    raise "wrap given text in resulting SSML element"
  end

  def combine(annotation)
    raise "combine this annotation with the given annotation of the same type"
  end
end
