require 'logger'
require 'abstract_controller'

require 'action_sms/config'
require 'action_sms/base'
require 'action_sms/sms'
require 'action_sms/providers'

module ActionSms
  # Configuration
  extend Config
  
  def self.configure
    yield self if block_given?
  end
end
