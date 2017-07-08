# frozen_string_literal: true

module RussianInflect
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
          dictionary[group] = RussianInflect::Dictionary.new(rules)
        end
      end
    end

    load_dictionary YAML.load_file(File.expand_path('../rules.yml', __FILE__))
  end
end
