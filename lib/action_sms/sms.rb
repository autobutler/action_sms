require 'net/http'

module ActionSms
  # A pending SMS  
  class SMS
    INVALID_PHONE_NUMBER = "Invalid phone number: %s"

    attr_accessor :phone_number, :body, :block
    
    def initialize(phone = "", body = "")
      @phone_number = phone.gsub(/\s+/,'')
      @body = body
      @sent = false
    end
    
    # Assign options, hash-style
    def []= (k,v)
      send("#{k}=",v)
    end
    
    def valid?
      @phone_number.match(/[0-9]{8}/)
    end
    
    # Returns true if the SMS was sent successfully.
    def deliver
      unless valid?
        after_send(false, INVALID_PHONE_NUMBER % @phone_number)
        return false
      end

      ActionSms::provider.deliver(self)
    end

    def after_send(delivered, status_message)
      block.call(delivered, status_message) if block.present?
      @sent = true
    end
  end
end