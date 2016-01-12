require 'rubygems'
require 'pry'
require 'webmock/rspec'
require 'action_sms'

WebMock.disable_net_connect!(allow_localhost: true)
