require_relative 'annotation'

require 'pathname'

module SSMD::Annotations
  class PhonemeAnnotation < Annotation
    attr_reader :x_sampa, :ipa

    def self.regex
      /ph: ?(.+)/
    end

    def initialize(x_sampa)
      @x_sampa = x_sampa
      @ipa = x_sampa_to_ipa x_sampa
    end

    def wrap(text)
      "<phoneme alphabet=\"ipa\" ph=\"#{ipa}\">#{text}</phoneme>"
    end

    def combine(annotation)
      self # discard further phoneme annotations
    end

    def x_sampa_to_ipa(input)
      x_sampa_to_ipa_table.inject(input) do |text, (x_sampa, ipa)|
        text.gsub x_sampa, ipa
      end
    end

    def x_sampa_to_ipa_table
      @table ||= begin
        lines = File.read(x_sampa_to_ipa_table_file_path).lines

        lines.map { |line| line.split(" ") }
      end
    end

    def x_sampa_to_ipa_table_file_path
      Pathname(SSMD.root_dir).join("lib/ssmd/annotations/xsampa_to_ipa_table.txt")
    end
  end
end
