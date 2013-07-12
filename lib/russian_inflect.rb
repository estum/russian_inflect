# encoding: UTF-8

require 'yaml'
require 'unicode_utils'
require 'active_support'
require 'russian_inflect/rules'
require "russian_inflect/version"

class RussianInflect
  CASES = [:nominative, :genitive, :dative, :accusative, :instrumental, :prepositional]
  GROUPS = [nil, :first, :second, :third]
  
  NOMINATIVE      = :nominative    # именительный
  GENITIVE        = :genitive      # родительный
  DATIVE          = :dative        # дательный
  ACCUSATIVE      = :accusative    # винительный
  INSTRUMENTAL    = :instrumental  # творительный
  PREPOSITIONAL   = :prepositional # предложный
  
  attr_accessor :words, :noun, :case_group
  
  def initialize(text, options = {})
    @words = text.split
    @noun = case options[:noun]
            when String then options[:noun]
            when Fixnum then @words[options[:noun]]
            else @words[0]
            end
    group = options[:group].presence || self.class.detect_case_group(@noun)
    @case_group = GROUPS[group]
  end
  
  def to_case(gcase)
    after_prepositions = false
    inflected_words = words.map do |word|
      result = word
      unless after_prepositions
        if word.in?(RULES['prepositions'])
          after_prepositions = true
        else
          result = Rules.new(case_group).inflect(word, gcase)
        end
      end
      result
    end
    inflected_words.join(' ')
  end
  
  def self.detect_case_group(noun)
    case noun
    when /(а|я|и)$/i then 1
    when /(о|е|ы)$/i then 2
    when /(мя|ь)$/i then 3
    else 2
    end
  end
  
  def self.detect_type(word)
    case word
    when /(ая|яя|ые|ие|ый|ий|ое|ее)$/i then :adjective
    else :noun
    end
  end
end