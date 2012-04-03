# -*- coding: utf-8 -*-

require 'spec_helper'

describe ActionSms::Providers::CoolSmsProvider do
  before do
    ActionSms::provider = :cool_sms
    ActionSms::options = { :user => "myUser", :password => "myPassword" }
  end
  
  after do
    ActionSms::provider = :test
  end
  
  it "should set the username and password in the url correctly" do
    m = ActionSms::SMS.new("12345678", "the text")
    url = ActionSms::provider.url(m).to_s
    url.should include("myUser")
    url.should include("myPassword")
  end
  
  describe "has correct error string" do
    it "for http errors" do
      Net::HTTP.stub!(:get_response).and_raise(StandardError.new("expected error"))
      m = ActionSms::SMS.new("12345678", "the text")
      m.block = Proc.new do |status, msg|
        status.should == false
        msg.should include("Exception")
        msg.should include("expected error")
      end
      m.deliver
    end
    
    it "for SMS gateway errors" do
      Net::HTTP.stub!(:get_response).and_return(stub(:code => "701"))
      m = ActionSms::SMS.new("12345678", "the text")
      m.block = Proc.new do |status, msg|
        status.should == false
        msg.should include("SMS Gateway Error Code")
        msg.should include("701")
      end
      m.deliver
    end

    it "for incorrect phone numbers" do
      Net::HTTP.stub!(:get_response).and_return(stub(:code => "200"))
      m = ActionSms::SMS.new("1234abcd", "the text")
      m.block = Proc.new do |status, msg|
        status.should == false
        msg.should include("Invalid phone number")
        msg.should include("1234abcd")
      end
      m.deliver
    end

    it "for normal SMS deliveries" do
      Net::HTTP.stub!(:get_response).and_return(stub(:code => "200"))
      m = ActionSms::SMS.new("12345678", "the text")
      m.block = Proc.new do |status,msg|
        status.should == true
        msg.should == "SMS sent"
      end
      m.deliver
    end
  end
  
  it "escapes message bodies correctly" do
    lambda {
      sms = ActionSms::SMS.new("12345678", "the_test_/&?æøå\\\\\\\\")
      ActionSms::Providers::CoolSmsProvider.url(sms)
    }.should_not raise_error
  end
end
