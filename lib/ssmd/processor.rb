class Processor
  attr_reader :match

  def matches?(input)
    @match = regex.match input

    !match.nil?
  end

  def substitute(input)
    if match
      match.pre_match + result + match.post_match
    end
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
