# encoding: UTF-8

class RussianInflect
  RULES = YAML.load_file(File.expand_path 'rules.yml', File.dirname(__FILE__))
  
  class UnknownCaseException < Exception;;end
  class UnknownRuleException < Exception;;end

  # Набор методов для нахождения и применения правил к имени, фамилии и отчеству.
  class Rules
    def initialize(args)
      @group = args
    end
    
    def inflect(word, gcase)
      type = RussianInflect.detect_type(word)
      find_and_apply(word, gcase, RussianInflect::RULES["#{@group.to_s}_group"][type.to_s])
    end
    
    protected

    def match?(name, rule, match_whole_word)
      name = UnicodeUtils.downcase(name)
      rule['test'].each do |chars|
        test = match_whole_word ? name : name.slice([name.size - chars.size, 0].max .. -1)        
        return true if test == chars
      end

      false
    end

    # Применить правило
    def apply(name, gcase, rule)
      modificator_for(gcase, rule).each_char do |char|
        case char
        when '.'
        when '-'
          name = name.slice(0, name.size - 1)
        else
          name += char
        end
      end

      name
    end

    # Найти правило и применить к имени с учетом склонения
    def find_and_apply(name, gcase, rules)
      rule = find_for(name, rules)
      apply(name, gcase, rule)
    rescue UnknownRuleException
      # Если не найдено правило для имени, возвращаем неизмененное имя.
      name
    end

    # Найти подходящее правило в исключениях или суффиксах
    def find_for(name, rules)
      # Сначала пытаемся найти исключения
      if rules.has_key?('exceptions')
        p = find(name, rules['exceptions'], true)
        return p if p
      end

      # Не получилось, ищем в суффиксах. Если не получилось найти и в них,
      # возвращаем неизмененное имя.
      find(name, rules['suffixes'], false) or raise UnknownRuleException, "Cannot find rule for #{name}"
    end

    # Найти подходящее правило в конкретном списке правил
    def find(name, rules, match_whole_word)
      rules.find { |rule| match?(name, rule, match_whole_word) }
    end

    # Получить модификатор из указанного правиля для указанного склонения
    def modificator_for(gcase, rule)
      case gcase.to_sym
      when NOMINATIVE
        '.'
      when GENITIVE
        rule['mods'][0]
      when DATIVE
        rule['mods'][1]
      when ACCUSATIVE
        rule['mods'][2]
      when INSTRUMENTAL
        rule['mods'][3]
      when PREPOSITIONAL
        rule['mods'][4]
      else
        raise UnknownCaseException, "Unknown grammatic case: #{gcase}"
      end
    end
  end
end