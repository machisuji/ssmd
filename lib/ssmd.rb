require "ssmd/version"
require "ssmd/converter"

module SSMD
  module_function

  ##
  # Translates the given SSMD text to SSML.
  #
  # @param ssmd [String] The SSMD markup to be converted to SSML
  # @param skip [Array<Symbol>] Formats (e.g. `:paragraph`, `:prosody`) to skip.
  #
  # @return [String] Resulting SSML
  def to_ssml(ssmd, skip: [])
    Converter.new(ssmd, skip: skip).convert
  end

  ##
  # Returns the given string without any SSMD annotations.
  # For instance for `hello *world*` would return `hello world`.
  #
  # @param ssmd [String] The SSMD markup to strip from SSMD annotations.
  # @param skip [Array<Symbol>] Formats (e.g. `:paragraph`, `:prosody`) to skip.
  #
  # @return [String]
  def strip_ssmd(ssmd, skip: [])
    Converter.new(ssmd, skip: skip).strip
  end

  def root_dir
    Gem::Specification.find_by_name("ssmd").gem_dir
  end
end
