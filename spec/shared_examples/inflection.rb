RSpec.shared_examples 'inflection' do |answers|
  describe answers[0] do
    let(:inflector) { RussianInflect::Inflector.new(answers[0]) }

    RussianInflect::CASES.each_with_index do |inflection_case, index|
      context "with case #{inflection_case}" do
        it 'inflects through inflector' do
          expect(inflector.to_case(inflection_case)).to eq(answers[index])
        end

        it 'inflects through module method' do
          expect(RussianInflect.inflect(answers[0], inflection_case)).to eq(answers[index])
        end
      end
    end
  end
end
