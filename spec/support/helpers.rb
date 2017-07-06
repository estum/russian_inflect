# frozen_string_literal: true

class Minitest::Spec
  def self.it_inflects(answers)
    describe answers[0] do
      let(:inflector) { RussianInflect::Inflector.new(answers[0]) }

      RussianInflect::CASES.each_with_index do |inflection_case, index|
        describe "Case: #{inflection_case}" do
          it 'inflects through inflector' do
            assert { inflector.to_case(inflection_case) == answers[index] }
          end

          it 'inflects through module method' do
            assert { RussianInflect.inflect(answers[0], inflection_case) == answers[index] }
          end
        end
      end
    end
  end
end
