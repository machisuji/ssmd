require_relative 'processor'

module SSMD::Processors
  class BreakProcessor < Processor
    def result
      name, value = attribute

      "<break #{name}=\"#{value}\"/>"
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
  end
end
