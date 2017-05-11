require "ssmd/version"
require "ssmd/converter"

module SSMD
  module_function

  def to_ssml(ssmd)
    Converter.new(ssmd).convert
  end
end
