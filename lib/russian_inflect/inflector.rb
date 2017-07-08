# frozen_string_literal: true

module RussianInflect
  class Inflector
    GROUPS = [nil, :first, :second, :third].freeze

    attr_accessor :source, :words, :noun, :case_group

    def initialize(source, options = {})
      @source = source       # Исходное предложение
      @words  = source.split # Разбиваем на слова

      # Пытаемся вычленить из предложения существительное
      @noun = case options[:noun]
              when String  then options[:noun] # Либо передаем существительное строкой
              when Integer then @words[options[:noun]] # Либо индексом в предложении
              else              @words.detect { |w| RussianInflect::Detector.new(w).noun? }
              end               # Либо определяем тип слова автоматически

      # Определяем группу существительного
      @case_group = options.fetch(:group) { RussianInflect::Detector.new(@noun).case_group }
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
            word = RussianInflect::Rules[GROUPS[@case_group]].inflect(word, downcased, gcase)
            word = UnicodeUtils.downcase(word) if force_downcase
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
        RussianInflect::Detector.new(word).case_group != @case_group ||
        (prev_type == :noun && current_type == :noun)
    end
  end
end
