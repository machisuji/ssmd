require_relative 'processor'

module SSMD::Processors
  class BreakProcessor < Processor
    def result
      name, value = attribute

      "<break #{name}=\"#{value}\"/>"
    end

    def text
      ""
    end

    def regex
      /(?<=\s)\.\.\.(?:(?<comma>c)|(?<sentence>s)|(?<paragraph>p)|(?<s>\d+s)|(?<ms>\d+ms)|(?<num>\d+))?(?=\s)/
    end

    def attribute
      if ms = (match[:num] || match[:ms])
        if ms == "0"
          ["strength", "none"]
        else
          ["time", "#{ms.to_i}ms"]
        end
      elsif s = match[:s]
        ["time", "#{s.to_i}s"]
      elsif match[:paragraph]
        ["strength", "x-strong"]
      elsif match[:sentence]
        ["strength", "strong"]
      elsif match[:comma]
        ["strength", "medium"]
      else
        ["strength", "x-strong"]
      end
    end

    private

    def join_parts(prefix, text, suffix)
      leading_ws = /\A\s/
      trailing_ws = /\s\z/

      if prefix =~ trailing_ws && suffix =~ leading_ws && text == ""
        prefix.sub(trailing_ws, "") + suffix
      else
        super
      end
    end
  end
end
