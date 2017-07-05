module RussianInflect
  NOMINATIVE    = :nominative    # именительный
  GENITIVE      = :genitive      # родительный
  DATIVE        = :dative        # дательный
  ACCUSATIVE    = :accusative    # винительный
  INSTRUMENTAL  = :instrumental  # творительный
  PREPOSITIONAL = :prepositional # предложный

  CASES = [NOMINATIVE, GENITIVE, DATIVE, ACCUSATIVE, INSTRUMENTAL, PREPOSITIONAL].freeze
end
