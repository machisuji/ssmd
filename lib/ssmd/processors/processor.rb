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
      join_parts match.pre_match, result, match.post_match if match
    end

    def strip_ssmd(input)
      join_parts match.pre_match, text, match.post_match if match
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

    private

    def join_parts(prefix, text, suffix)
      [prefix, text, suffix].join
    end
  end
end
