module ActionSms
  module Providers
    class TestProvider < Provider
      def self.deliver(m)
        m.after_send(true, "TestProvider: SMS sent.")
        return true
      end
    end
  end
end
