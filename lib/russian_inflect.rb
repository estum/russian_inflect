require 'yaml'
require 'unicode_utils'
require 'russian_inflect/rules'
require "russian_inflect/version"

class RussianInflect
  NOMINATIVE      = :nominative    # именительный
  GENITIVE        = :genitive      # родительный
  DATIVE          = :dative        # дательный
  ACCUSATIVE      = :accusative    # винительный
  INSTRUMENTAL    = :instrumental  # творительный
  PREPOSITIONAL   = :prepositional # предложный

  CASES = [NOMINATIVE, GENITIVE, DATIVE, ACCUSATIVE, INSTRUMENTAL, PREPOSITIONAL]
  GROUPS = [nil, :first, :second, :third]

  attr_accessor :source, :words, :noun, :case_group

  def initialize(source, options = nil)
    options ||= {}

    @source = source
    @words  = source.split

    @noun = case options[:noun]
            when String then options[:noun]
            when Fixnum then @words[options[:noun]]
            else @words.detect { |w| self.class.detect_type(w) == :noun }
            end
    group = options.fetch(:group) { self.class.detect_case_group(@noun) }
    @case_group = GROUPS[group]
  end

  def to_case(gcase, force_downcase: false)
    after_prepositions = false
    prev_type = nil

    inflected_words = words.map do |word|
      unless after_prepositions
        downcased = UnicodeUtils.downcase(word)
        current_type = self.class.detect_type(word)
        if preposition?(downcased, prev_type, current_type)
          after_prepositions = true
        else
          result = Rules[case_group].inflect(downcased, gcase)
          word = if force_downcase
            result
          else
            len = downcased.each_char.take_while.with_index { |x, n| x == result[n] }.size
            word[0, len] << result[len..-1]
          end
        end
        prev_type = current_type
      end

      word
    end

    inflected_words.join(' ')
  end

  def preposition?(word, prev_type, current_type)
    Rules.prepositions.include?(word) ||
      GROUPS[self.class.detect_case_group(word)] != @case_group ||
      (prev_type == :noun && current_type == :noun)
  end

  def self.inflect(text, gcase, force_downcase: false)
    new(text).to_case(gcase, force_downcase: force_downcase)
  end

  def self.detect_case_group(noun)
    case noun
    when /(а|я|и)$/i then 1
    when /(о|е|ы)$/i then 2
    when /(мя|ь)$/i  then 3
                     else 2
    end
  end

  def self.detect_type(word)
    case word
    when /(ая|яя|ые|ие|ый|ой|[^р]ий|ое|ее)$/i then :adjective
                                              else :noun
    end
  end
end
