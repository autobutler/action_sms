module ActionSms
  module Providers
    class CoolSmsProvider < Provider
      DELIVERED_OK = "SMS sent"
      DELIVER_EXCEPTION = "Exception: %s"
      SMS_GATEWAY_ERROR = "SMS Gateway Error Code: %s"

      def self.url(message)
        uri = "http://sms.coolsmsc.dk:8080/?username=#{ActionSms::options[:user]}&password=#{ActionSms::options[:password]}&resulttype=urlencoded"
        uri += "&to=#{message.phone_number}"
        uri += "&from=#{ActionSms::options[:from]}"
        uri += "&message=#{CGI::escape(message.body.encode("Windows-1252"))}"
        uri += "&status=on&statusurl=#{message.status_report_url}" if message.status_report_url.present?
        URI(uri)
      end
      
      def self.deliver(m)
        all_ok = false

        begin
          response = Net::HTTP::get_response(url(m))
          all_ok = response.code == "200"
          if all_ok
            parsed_response = Rack::Utils.parse_query(response.body)
            m.message_id = parsed_response["msgid"]
            m.after_send(true, DELIVERED_OK)
          else
            m.after_send(false, SMS_GATEWAY_ERROR % response.code)
          end
        rescue URI::InvalidURIError => e
          m.after_send(false, DELIVER_EXCEPTION % e.to_s)
        rescue StandardError => e
          m.after_send(false, DELIVER_EXCEPTION % e.to_s)
        end

        all_ok        
      end
    end
  end
end
