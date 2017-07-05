class RussianInflect
  class Inflector
    GROUPS = [nil, :first, :second, :third].freeze

    attr_accessor :source, :words, :noun, :case_group

    def initialize(source, options = nil)
      options ||= {}

      @source = source
      @words  = source.split

      @noun = case options[:noun]
              when String then options[:noun]
              when Fixnum then @words[options[:noun]]
              else @words.detect { |w| RussianInflect::Detector.new(w).noun? }
              end
      group = options.fetch(:group) { RussianInflect::Detector.new(@noun).case_group }
      @case_group = GROUPS[group]
    end

    def to_case(gcase, force_downcase: false)
      after_prepositions = false
      prev_type = nil

      inflected_words = words.map do |word|
        unless after_prepositions
          downcased = UnicodeUtils.downcase(word)
          current_type = RussianInflect::Detector.new(word).word_type
          if preposition?(downcased, prev_type, current_type)
            after_prepositions = true
          else
            result = RussianInflect::Rules[case_group].inflect(downcased, gcase)
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
      RussianInflect::Rules.prepositions.include?(word) ||
        GROUPS[RussianInflect::Detector.new(word).case_group] != @case_group ||
        (prev_type == :noun && current_type == :noun)
    end
  end
end
