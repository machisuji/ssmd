require "ssmd/version"

module SSMD
  module_function

  def to_ssml(ssmd)
    ssmd.gsub(/\*([^\*]+)\*/, '<emphasis>\1</emphasis>')
  end
end
