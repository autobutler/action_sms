module ActionSms
  module Providers
    class TestProvider < Provider
      def self.deliver(m)
        ActionSms::logger.info "SMS message for #{m.phone_number}: #{m.body}"
        m.after_send(true, "TestProvider: SMS sent.")
        return true
      end
    end
  end
end