class SpecParser
  attr_reader :spec

  def initialize
    @spec = Spec.new
  end

  def self.parse(file_name)
    parser = SpecParser.new
    lines = File.read(file_name).lines

    parser.parse! lines
    parser.spec
  end

  def parse!(lines)
    line, *rest_lines = lines

    if line.nil?
      if Array(rest_lines).empty? # done parsing
        return true
      else # parse rest
        return parse! rest_lines
      end
    elsif line.strip.empty? # skip empty lines
      return parse! rest_lines
    end

    if case_title? line
      @next_title = line.gsub(/\A###/, "").strip
      @expect_case = false
    elsif line.strip == "***"
      @expect_case = true
      @next_title = nil
      @next_input = nil
      @next_output = nil
    elsif result = SnippetParser.new.read(lines)
      snippet, next_lines = result

      if @next_title && @next_input.nil?
        @next_input = snippet

        return parse! next_lines
      elsif @next_title && @next_output.nil?
        next_output = snippet

        if @next_title && @next_input
          spec.cases.push SpecCase.new(@next_title, @next_input.strip, next_output.strip)
        end

        @next_title = nil
        @next_input = nil

        return parse! next_lines
      end
    end

    parse! rest_lines # discard line and parse rest
  end

  def case_title?(line)
    expect_case? && line.strip =~ /\A###/
  end

  def expect_case?
    @expect_case
  end
end

##
# Example:
#
#     SSMD:
#     ```html
#     <speak>text</speak>
#     ```
class SnippetParser
  def read(lines)
    if snippet? lines
      read_snippet lines.drop(2)
    end
  end

  private

  def read_snippet(lines, snippet = "")
    line, *rest = lines

    if line.strip == "```"
      [snippet, rest]
    else line.nil?
      nil
    else
      read_snippet rest, snippet + line
    end
  end

  def snippet?(lines)
    one, two = lines.take(2).map(&:strip)

    one =~ /\ASSM[DL]:\Z/ && two =~ /\A```(html)?\Z/
  end
end

class Spec
  attr_reader :cases

  def initialize(cases = [])
    @cases = cases
  end
end

class SpecCase
  attr_reader :title, :input, :output

  def initialize(title, input = nil, output = nil)
    @title = title
    @input = input
    @output = output
  end
end
