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
      should_modify = true
      prev_type = nil

      # Проходимся по каждому слову
      inflected_words = words.map do |word|
        if should_modify # Используем внешнюю переменную для хранения режима (пахнет)
          downcased = UnicodeUtils.downcase(word) # Даункейсим слово в чистом руби
          current_type = RussianInflect::Detector.new(word).word_type # Детектим тип слова

          # Еще одна внешняя переменная с предыдущим состоянием (пахнет)
          if adverbal?(downcased, prev_type, current_type)
            # Все это нужно для предложений вида "Камень в реке", чтобы "в реке" не склонялось
            should_modify = false
          else
            word = RussianInflect::Rules[GROUPS[@case_group]].inflect(word, downcased, gcase)
            word = UnicodeUtils.downcase(word) if force_downcase
            prev_type = current_type
          end
        end

        word
      end

      inflected_words.join(' ')
    end

    # Является ли текущее слово началом дополнительной (и несклоняющейся) части предложения?
    def adverbal?(word, prev_type, current_type)
      RussianInflect::Rules.prepositions.include?(word) ||
        RussianInflect::Detector.new(word).case_group != @case_group ||
        (prev_type == :noun && current_type == :noun)
    end
  end
end
