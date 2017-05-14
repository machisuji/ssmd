require_relative 'annotation'

module SSMD::Annotations
  class ProsodyAnnotation < Annotation
    attr_reader :volume, :rate, :pitch

    def self.regex
      /(?:vrp: ?(\d{3}))|(?:([vrp]): ?(\d))/
    end

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
        ("volume=\"#{volume}\"" if volume),
        ("rate=\"#{rate}\"" if rate),
        ("pitch=\"#{pitch}\"" if pitch)
      ]

      "<prosody #{attributes.join(' ')}>#{text}</prosody>"
    end

    def combine(annotation)
      @volume ||= annotation.volume
      @rate ||= annotation.rate
      @pitch ||= annotation.pitch

      self
    end

    private

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

    def set_vrp!(vrp)
      @volume = volumes.fetch Integer(vrp[0])
      @rate = rates.fetch Integer(vrp[1])
      @pitch = pitches.fetch Integer(vrp[2])
    end

    def set_tuples!(tuples)
      tuples.each_slice(2).each do |key, value|
        case key
        when 'v'
          @volume = volumes.fetch Integer(value)
        when 'r'
          @rate = rates.fetch Integer(value)
        when 'p'
          @pitch = pitches.fetch Integer(value)
        end
      end
    end
  end
end
