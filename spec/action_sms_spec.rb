require 'spec_helper'

describe ActionSms do
  it "should be able to set test provider" do
    ActionSms::provider = :test
  end

  it "should be able to set an option" do
    ActionSms::options[:user] = "halfdan"
    expect(ActionSms::options).to have_key(:user)
    expect(ActionSms::options[:user]).to eq "halfdan"
  end
end
