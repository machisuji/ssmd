require_relative 'annotation'

module SSMD::Annotations
  class ProsodyAnnotation < Annotation
    class << self
      def regex
        /(?:vrp: ?(\d{3}))|(?:([vrp]): ?(\d))/
      end

      def volumes
        {
          0 => "silent",
          1 => "x-soft",
          2 => "soft",
          3 => "medium",
          4 => "loud",
          5 => "x-loud"
        }
      end

      def rates
        {
          1 => "x-slow",
          2 => "slow",
          3 => "medium",
          4 => "fast",
          5 => "x-fast"
        }
      end

      def pitches
        {
          1 => "x-low",
          2 => "low",
          3 => "medium",
          4 => "high",
          5 => "x-high"
        }
      end
    end

    attr_reader :volume, :rate, :pitch

    def initialize(vrp, *tuples)
      begin
        if vrp && vrp.size == 3
          set_vrp! vrp
        elsif tuples.compact.size % 2 == 0
          set_tuples! tuples.take(6)
        else
          # ignore invalid values
        end
      rescue ArgumentError
        # ignore if there are invalid values
      end
    end

    def wrap(text)
      attributes = [
        "",
        ("volume=\"#{volume}\"" if volume),
        ("rate=\"#{rate}\"" if rate),
        ("pitch=\"#{pitch}\"" if pitch)
      ]
        .compact

      "<prosody#{attributes.join(' ')}>#{text}</prosody>"
    end

    def combine(annotation)
      @volume ||= annotation.volume
      @rate ||= annotation.rate
      @pitch ||= annotation.pitch

      self
    end

    private

    def set_vrp!(vrp)
      @volume = self.class.volumes.fetch Integer(vrp[0])
      @rate = self.class.rates.fetch Integer(vrp[1])
      @pitch = self.class.pitches.fetch Integer(vrp[2])
    end

    def set_tuples!(tuples)
      tuples.each_slice(2).each do |key, value|
        case key
        when 'v'
          @volume = self.class.volumes.fetch Integer(value)
        when 'r'
          @rate = self.class.rates.fetch Integer(value)
        when 'p'
          @pitch = self.class.pitches.fetch Integer(value)
        end
      end
    end
  end
end
