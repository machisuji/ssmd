require_relative 'processor'

module SSMD::Processors
  class ProsodyProcessor < Processor
    def result
      with_volume || with_rate || with_pitch
    end

    def text
      match.captures.compact.first
    end

    def regex
      @regex ||= Regex.prosody
    end

    private

    def with_volume
      name, text = volume_keys.map { |k| [k, match[k]] }.find { |k, v| !v.nil? }

      "<prosody volume=\"#{name}\">#{text}</prosody>" if name && text
    end

    def with_rate
      name, text = rate_keys.map { |k| [k, match[k]] }.find { |k, v| !v.nil? }

      "<prosody rate=\"#{name}\">#{text}</prosody>" if name && text
    end

    def with_pitch
      name, text = pitch_keys.map { |k| [k, match[k]] }.find { |k, v| !v.nil? }

      "<prosody pitch=\"#{name}\">#{text}</prosody>" if name && text
    end

    def volume_keys
      ['silent', 'x-soft', 'soft', 'loud', 'x-loud']
    end

    def rate_keys
      ['x-slow', 'slow', 'fast', 'x-fast']
    end

    def pitch_keys
      ['x-low', 'low', 'high', 'x-high']
    end

    module Regex
      module_function

      def prosody
        %r{
          (?:#{slow_rate}) |
          (?:#{fast_rate}) |
          (?:#{silent_volume}) |
          (?:#{soft_volume}) |
          (?:#{loud_volume}) |
          (?:#{low_pitch}) |
          (?:#{high_pitch})
        }x
      end

      ##
      # Match example: ~silent~
      def silent_volume
        /#{ws_start}~#{content('silent')}~#{ws_end}/
      end

      ##
      # Match example: --extra soft-- or -soft-
      def soft_volume
        /(?:#{ws_start}--#{content('x-soft')}--#{ws_end})|(?:#{ws_start}-#{content('soft')}-#{ws_end})/
      end

      ##
      # Match example: ++extra loud or +loud+
      def loud_volume
        /(?:#{ws_start}\+\+#{content('x-loud')}\+\+#{ws_end})|(?:#{ws_start}\+#{content('loud')}\+#{ws_end})/
      end

      ##
      # Match example: <<extra slow<< or <slow<
      def slow_rate
        /(?:#{ws_start}&lt;&lt;#{content('x-slow')}&lt;&lt;#{ws_end})|(?:#{ws_start}&lt;#{content('slow')}&lt;#{ws_end})/
      end

      ##
      # Match example: >>extra fast>> or >fast>
      def fast_rate
        /(?:#{ws_start}&gt;&gt;#{content('x-fast')}&gt;&gt;#{ws_end})|(?:#{ws_start}&gt;#{content('fast')}&gt;#{ws_end})/
      end

      ##
      # Match example: __extra low__ or _low_
      def low_pitch
        /(?:#{ws_start}__#{content('x-low')}__#{ws_end})|(?:#{ws_start}_#{content('low')}_#{ws_end})/
      end

      ##
      # Match example: ^^extra high^^ or ^high^
      def high_pitch
        /(?:#{ws_start}\^\^#{content('x-high')}\^\^#{ws_end})|(?:#{ws_start}\^#{content('high')}\^#{ws_end})/
      end

      ##
      # Matches either a single char or a longer string starting and ending
      # with a non-whitespace char.
      def content(name = nil)
        id = name ? "?<#{name}>" : ""
        /(#{id}(?:[^\s])|(?:[^\s].*[^\s]))/
      end

      ##
      # Matches the beginning of the input or a whitespace char via lookbehind,
      # meaning it's excluded from the match result.
      def ws_start
        /(?<=(\A)|(?:\s))/
      end

      ##
      # Matches the end of the input or a whitespace char via lookahead,
      # meaning it's excluded from the match result.
      def ws_end
        /(?=(\Z)|(?:\s))/
      end
    end
  end
end
