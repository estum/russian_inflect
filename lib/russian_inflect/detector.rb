module RussianInflect
  class Detector
    attr_accessor :word

    def initialize(word)
      @word = word
    end

    def case_group
      # Снова полагаемся на окончания
      case word
      when /(а|я|и)$/i                                                          then 1
      when /(о|е|ы|вль|поль|коль|куль|прель|обль|чутль|раль|варь|брь|пароль)$/i then 2
      when /(мя|ь)$/i                                                           then 3
      else                                                                           2
      end
    end

    def word_type
      # Полагаемся на окончания прилагательных, если в слове не они - значит у нас существительное
      case word
      when /(ая|яя|ые|ие|ый|ой|[^р]ий|ое|ее)$/i then :adjective
      else                                           :noun
      end
    end

    def noun?
      word_type == :noun
    end

    def adjective?
      word_type == :adjective
    end
  end
end
