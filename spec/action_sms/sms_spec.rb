require 'spec_helper'

describe ActionSms::SMS do
  it "handles invalid phone numbers sanely" do
    ['1234', 'abcde', '43bcd'].each do |number|
      ActionSms::SMS.new(number, "the text").should_not be_valid
    end
  end
  
  it "handles valid phone numbers correctly" do
    ActionSms::SMS.new("12345678", "the text").should be_valid
  end  
end
