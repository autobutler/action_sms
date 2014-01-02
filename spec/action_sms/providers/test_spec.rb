require 'spec_helper'

describe ActionSms::Providers::TestProvider do
  before do
    ActionSms::provider = :test
  end

  it "should deliver test messages" do
    m = ActionSms::SMS.new("12345678", "this is a test")
    m.deliver.should == true
  end
end
