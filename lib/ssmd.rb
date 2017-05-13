require "ssmd/version"
require "ssmd/converter"

module SSMD
  module_function

  def to_ssml(ssmd)
    Converter.new(ssmd).convert
  end

  def root_dir
    Gem::Specification.find_by_name("ssmd").gem_dir
  end
end
