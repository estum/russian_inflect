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
      inflected_words = inflecting_words.map do |word|
        downcased = UnicodeUtils.downcase(word) # Даункейсим слово в чистом руби
        word = RussianInflect::Rules[GROUPS[@case_group]].inflect(word, downcased, gcase)
        force_downcase ? UnicodeUtils.downcase(word) : word
      end

      (inflected_words + adverbal).join(' ')
    end

    private

    # Является ли текущее слово началом дополнительной (и несклоняющейся) части предложения?
    def adverbal_start?(word, prev_type, current_type)
      RussianInflect::Rules.prepositions.include?(word) ||
        RussianInflect::Detector.new(word).case_group != @case_group ||
        (prev_type == :noun && current_type == :noun)
    end

    def adverbal
      return [] if words.length == 1
      return [] if adverbal_index == -1
      words[adverbal_index..-1]
    end

    def adverbal_index
      @adverbal_index ||= begin
        prev_type = nil

        words.each_with_index do |word, index|
          downcased = UnicodeUtils.downcase(word) # Даункейсим слово в чистом руби
          current_type = RussianInflect::Detector.new(word).word_type # Детектим тип слова
          return index if adverbal_start?(downcased, prev_type, current_type)
          prev_type = current_type
        end

        -1
      end
    end

    def inflecting_words
      return words if words.length == 1
      return words if adverbal_index == -1
      words[0..(adverbal_index - 1)]
    end
  end
end
