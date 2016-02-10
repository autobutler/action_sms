require 'spec_helper'

describe ActionSms::SMS do
  it "handles invalid phone numbers sanely" do
    ['1234', 'abcde', '43bcd'].each do |number|
      expect(ActionSms::SMS.new(number, "the text")).to_not be_valid
    end
  end

  it "handles valid phone numbers correctly" do
    expect(ActionSms::SMS.new("12345678", "the text")).to be_valid
  end
end
