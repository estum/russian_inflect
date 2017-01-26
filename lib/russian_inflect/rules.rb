module RussianInflect
  UnknownError = Class.new(StandardError)

  class UnknownCaseException < UnknownError
    def initialize(gcase)
      super "Unknown grammatical case: `#{gcase}'."
    end
  end

  class UnknownRuleException < UnknownError
    def initialize(name)
      super "Can't find rule for `#{name}'."
    end
  end

  Rules = Struct.new(:group, :rules)

  # Набор методов для нахождения и применения правил к имени, фамилии и отчеству.
  class Rules
    class << self
      def prepositions
        @prepositions ||= []
      end

      def dictionary
        @dictionary ||= {}
      end

      def [](group)
        dictionary.fetch(group)
      end

      def load_dictionary(hash)
        @prepositions = Array(hash[:prepositions])
        hash[:rules].each do |group, rules|
          dictionary[group] = new(group, rules)
        end
      end
    end

    load_dictionary YAML.load_file(File.expand_path('../rules.yml', __FILE__))

    def inflect(word, gcase)
      type = RussianInflect::Detector.new(word).word_type
      find_and_apply(word, gcase, type)
    end

    protected

    # Найти правило и применить к имени с учетом склонения
    def find_and_apply(name, gcase, type)
      apply(name, gcase, find_for(name, type))
    rescue UnknownRuleException
      name
    end

    # Найти подходящее правило в исключениях или суффиксах
    def find_for(name, type)
      if scoped_rules = rules[type][:exceptions]
        ex = find(name, scoped_rules, true)
        return ex if ex
      else
        scoped_rules = rules[type][:suffixes]
      end

      find(name, scoped_rules) || raise(UnknownRuleException, name)
    end

    def find(name, scoped_rules, match_whole_word = false)
      scoped_rules.detect { |rule| match?(name, rule, match_whole_word) }
    end

    # Проверить правило
    def match?(word, rule, match_whole_word = false)
      # word = UnicodeUtils.downcase(word)

      rule[:test].any? do |chars|
        test = match_whole_word ? word : word.slice([word.length - chars.length, 0].max..-1)
        test == chars
      end
    end

    # Применить правило
    def apply(word, gcase, rule)
      modificator = modificator_for(gcase, rule)
      result = word.dup

      modificator.each_char do |char|
        case char
        when '.'
        when '-' then result.slice!(-1)
                 else result << char
        end
      end

      result
    end

    # Получить модификатор из указанного правиля для указанного склонения
    def modificator_for(gcase, rule)
      case gcase.to_sym
      when NOMINATIVE    then '.'
      when GENITIVE      then rule[:mods][0]
      when DATIVE        then rule[:mods][1]
      when ACCUSATIVE    then rule[:mods][2]
      when INSTRUMENTAL  then rule[:mods][3]
      when PREPOSITIONAL then rule[:mods][4]
                         else raise UnknownCaseException, gcase
      end
    end
  end
end
