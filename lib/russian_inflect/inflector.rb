# frozen_string_literal: true

module RussianInflect
  class Inflector
    GROUPS = [nil, :first, :second, :third].freeze

    attr_accessor :source, :words, :noun, :case_group

    def initialize(source, options = nil)
      options ||= {}

      @source = source       # Исходное предложение
      @words  = source.split # Разбиваем на слова

      # Пытаемся вычленить из предложения существительное
      @noun = case options[:noun]
              when String then options[:noun] # Либо передаем существительное строкой
              when Integer then @words[options[:noun]] # Либо индексом в предложении
              else
                # Либо определяем тип слова автоматически
                @words.detect { |w| RussianInflect::Detector.new(w).noun? }
              end

      # Определяем индекс группы существительного
      group = options.fetch(:group) { RussianInflect::Detector.new(@noun).case_group }

      # По индексу сохраняем группу
      @case_group = GROUPS[group]
    end

    def to_case(gcase, force_downcase: false)
      after_prepositions = false
      prev_type = nil

      # Проходимся по каждому слову
      inflected_words = words.map do |word|
        # Используем внешнюю переменную для хранения режима (пахнет)
        unless after_prepositions
          # Даункейсим слово в чистом руби
          downcased = UnicodeUtils.downcase(word)
          # Детектим тип слова
          current_type = RussianInflect::Detector.new(word).word_type

          # Еще одна внешняя переменная с предыдущим состоянием (пахнет)
          if preposition?(downcased, prev_type, current_type)
            # Все это нужно для предложений вида "Камень в реке", чтобы "в реке" не склонялось
            after_prepositions = true
          else
            result = RussianInflect::Rules[case_group].inflect(downcased, gcase)
            word = if force_downcase
                     result
                   else
                     # Возвращаем предложение в тот кейс, в котором оно изначально было
                     # Нужно делать, потому что склоняем мы только в даункейсе
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

    # Является ли текущее слово предлогом?
    def preposition?(word, prev_type, current_type)
      RussianInflect::Rules.prepositions.include?(word) ||
        GROUPS[RussianInflect::Detector.new(word).case_group] != @case_group ||
        (prev_type == :noun && current_type == :noun)
    end
  end
end
