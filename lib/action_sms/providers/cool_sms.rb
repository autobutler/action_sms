require 'rack'

module ActionSms
  module Providers
    class CoolSmsProvider < Provider
      DELIVERED_OK = "SMS sent"
      DELIVER_EXCEPTION = "Exception: %s"
      SMS_GATEWAY_ERROR = "SMS Gateway Error Code: %s"

      def self.deliver(message)
        all_ok = false

        begin
          url = "https://api-linkmobility-dk-dsq6w2hmnzdf.runscope.net/v2/message.json?apikey=#{ENV['COOLSMS_API_KEY']}"

          phone_number = '+' + message.phone_number unless message.phone_number.starts_with?('+')
          from = message.from.blank? ? ActionSms::options[:from] : message.from

          body = {
            message: {
              recipients: phone_number,
              sender: from,
              message: message.body
            }
          }

          if message.status_report_url.present?
            body[:message][:status] = true
            body[:message][:statusurl] = message.status_report_url
          end

          response = RestClient.post(url, body.to_json, content_type: 'application/json')

          all_ok = response.code == 201
          if all_ok
            parsed_response = JSON.parse(response.body)
            message.message_id = parsed_response['details']['batchid']
            message.after_send(true, DELIVERED_OK)
          else
            message.after_send(false, SMS_GATEWAY_ERROR % response.code)
          end
        rescue URI::InvalidURIError => e
          message.after_send(false, DELIVER_EXCEPTION % e.to_s)
        rescue StandardError => e
          message.after_send(false, DELIVER_EXCEPTION % e.to_s)
        end

        all_ok
      end
    end
  end
end
