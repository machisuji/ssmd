module SSMD::Processors
  class Processor
    attr_reader :match, :options

    def initialize(options = {})
      @options = options
    end

    def matches?(input)
      @match = regex.match input

      !match.nil?
    end

    def substitute(input)
      if match
        match.pre_match + result + match.post_match
      end
    end

    def strip_ssmd(input)
      if match
        match.pre_match + text + match.post_match
      end
    end

    def text
      match.captures.first
    end

    def result
      raise "subclass responsibility"
    end

    def regex
      raise "subclass responsibility"
    end

    def warnings
      @warnings ||= []
    end
  end
end
