require 'net/http'

module ActionSms
  # A pending SMS
  class SMS
    INVALID_PHONE_NUMBER = "Invalid phone number: %s"

    attr_accessor :phone_number, :body, :from, :block, :status_report_url, :message_id

    def initialize(phone = "", body = "", from = "")
      @phone_number = phone.gsub(/\s+/,'')
      @body = body
      @from = from || ActionSms::options[:from]
      @sent = false
    end

    # Assign options, hash-style
    def []= (k,v)
      send("#{k}=",v)
    end

    def valid?
      @phone_number =~ /[0-9]{8}[0-9]*/
    end

    def deliver
      warn '[DEPRECATION] `deliver` is deprecated.  Please use `deliver_now` instead.'
      deliver_now
    end

    # Returns true if the SMS was sent successfully.
    def deliver_now
      unless valid?
        after_send(false, INVALID_PHONE_NUMBER % @phone_number)
        return false
      end

      ActionSms::provider.deliver(self)
    end

    def sent?
      sent
    end

    def after_send(delivered, status_message)
      block.call(delivered, status_message) if block.present?
      @sent = true
    end
  end
end
