require "ssmd/version"
require "ssmd/converter"

module SSMD
  module_function

  def to_ssml(ssmd)
    Converter.new(ssmd).convert
  end

  ##
  # Returns the given string without any SSMD annotations.
  # For instance for `hello *world*` would return `hello world`.
  #
  # @return [String]
  def strip_ssmd(ssmd)
    Converter.new(to_ssml(ssmd)).strip
  end

  def root_dir
    Gem::Specification.find_by_name("ssmd").gem_dir
  end
end
