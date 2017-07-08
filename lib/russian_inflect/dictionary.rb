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
      # Склоняем слово по модификатору, который находим по падежу и правилу для слова
      modify(word, modificator_for(gcase, rule_for(word)))
    rescue UnknownRuleException
      word
    end

    private

    # Ищем правило в исключениях или суффиксах
    def rule_for(word)
      type = RussianInflect::Detector.new(word).word_type

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
      return rule[:test].include?(word) if match_whole_word
      rule[:test].any? { |chars| chars == word.slice([word.length - chars.length, 0].max..-1) }
    end

    # Применяем правило к слову
    def modify(word, modificator)
      return word if modificator == '.'
      word.slice(0..(-1 - modificator.count('-'))) + modificator.tr('-', '')
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
