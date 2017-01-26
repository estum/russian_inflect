RSpec.shared_examples 'inflection' do |answers|
  describe answers[0] do
    let(:inflection_object) { RussianInflect.new(answers[0]) }

    RussianInflect::CASES.each_with_index do |inflection_case, index|
      context "with case #{inflection_case}" do
        it 'inflects properly' do
          expect(inflection_object.to_case(inflection_case)).to eq(answers[index])
        end
      end
    end
  end
end
