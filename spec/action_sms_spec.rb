require 'spec_helper'

describe ActionSms do
  it "should be able to set test provider" do
    ActionSms::provider = :test
  end
  
  it "should be able to set an option" do
    ActionSms::options[:user] = "halfdan"
    ActionSms::options.should have_key(:user)
    ActionSms::options[:user].should == "halfdan"
  end
end
