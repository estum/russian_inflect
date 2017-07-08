# frozen_string_literal: true

module RussianInflect
  UnknownError = Class.new(StandardError)

  class UnknownCaseException < UnknownError
    def initialize(gcase)
      super "Unknown grammatical case: `#{gcase}'."
    end
  end

  class UnknownRuleException < UnknownError
    def initialize(word)
      super "Can't find rule for `#{word}'."
    end
  end

  class Dictionary
    def initialize(rules)
      @rules = rules
    end

    def inflect(word, gcase)
      type = RussianInflect::Detector.new(word).word_type
      apply(word, gcase, rule_for(word, type)) # Найти правило и применить к слову с учетом падежа
    rescue UnknownRuleException
      word
    end

    private

    # Ищем правило в исключениях или суффиксах
    def rule_for(word, type)
      find(word, @rules[type][:exceptions], true) ||
        find(word, @rules[type][:suffixes]) ||
        raise(UnknownRuleException, word)
    end

    def find(word, scoped_rules, match_whole_word = false)
      return if scoped_rules.nil?
      scoped_rules.detect { |rule| match?(word, rule, match_whole_word) }
    end

    # Проверяем, подходит ли правило под наше слово
    def match?(word, rule, match_whole_word = false)
      rule[:test].any? do |chars|
        test = match_whole_word ? word : word.slice([word.length - chars.length, 0].max..-1)
        test == chars
      end
    end

    # Применяем правило к слову
    def apply(word, gcase, rule)
      modificator = modificator_for(gcase, rule)
      result = word.dup

      modificator.each_char do |char|
        case char
        when '.' then nil
        when '-' then result.slice!(-1)
        else          result << char
        end
      end

      result
    end

    # Получить модификатор для указанного падежа из указанного правила
    def modificator_for(gcase, rule)
      case gcase.to_sym
      when NOMINATIVE    then '.'
      when GENITIVE      then rule[:mods][0]
      when DATIVE        then rule[:mods][1]
      when ACCUSATIVE    then rule[:mods][2]
      when INSTRUMENTAL  then rule[:mods][3]
      when PREPOSITIONAL then rule[:mods][4]
      else                    raise UnknownCaseException, gcase
      end
    end
  end
end
