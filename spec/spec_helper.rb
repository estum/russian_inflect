require 'russian_inflect'

class RussianInflect
  def self.each_case(&block)
    CASES.each_with_index &block
  end
  
  def test_each_case(*answers)
    puts ''
    RussianInflect.each_case do |c, index|
      result = self.to_case(c)
      puts %{RussianInflect.inflect("#{source}", :#{c})   # #{result}}
      result.should == answers[index]
    end
  end
end