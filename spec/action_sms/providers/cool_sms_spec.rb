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
    expect(url).to include("myUser")
    expect(url).to include("myPassword")
  end
  
  describe "has correct error string" do
    it "for http errors" do
      stub_request(:get, "http://sms.coolsmsc.dk:8080/?from=&message=the%20text&password=myPassword&resulttype=urlencoded&to=12345678&username=myUser").
        to_raise(StandardError.new("expected error"))
      m = ActionSms::SMS.new("12345678", "the text")
      m.block = Proc.new do |status, msg|
        expect(status).to eq false
        expect(msg).to include("Exception")
        expect(msg).to include("expected error")
      end
      m.deliver_now
    end
    
    it "for SMS gateway errors" do
      stub_request(:get, "http://sms.coolsmsc.dk:8080/?from=&message=the%20text&password=myPassword&resulttype=urlencoded&to=12345678&username=myUser").
        to_return(:status => 701, :body => "", :headers => {})
      m = ActionSms::SMS.new("12345678", "the text")
      m.block = Proc.new do |status, msg|
        expect(status).to eq false
        expect(msg).to include("SMS Gateway Error Code")
        expect(msg).to include("701")
      end
      m.deliver_now
    end

    it "for incorrect phone numbers" do
      m = ActionSms::SMS.new("1234abcd", "the text")
      m.block = Proc.new do |status, msg|
        expect(status).to eq false
        expect(msg).to include("Invalid phone number")
        expect(msg).to include("1234abcd")
      end
      m.deliver_now
    end

    it "for normal SMS deliveries" do
      stub_request(:get, "http://sms.coolsmsc.dk:8080/?from=&message=the%20text&password=myPassword&resulttype=urlencoded&to=12345678&username=myUser").
        to_return(:status => 200, :body => "status=success&msgid=12345", :headers => {})
      m = ActionSms::SMS.new("12345678", "the text")
      m.block = Proc.new do |status,msg|
        expect(status).to eq true
        expect(msg).to eq "SMS sent"
        expect(m.message_id).to eq "12345"
      end
      m.deliver_now
    end
  end
  
  it "escapes message bodies correctly" do
    expect {
      sms = ActionSms::SMS.new("12345678", "the_test_/&?æøå\\\\\\\\")
      ActionSms::Providers::CoolSmsProvider.url(sms)
    }.to_not raise_error
  end
end
