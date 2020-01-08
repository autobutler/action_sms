# frozen_string_literal: true

require 'rack'

module ActionSms
  module Providers
    class AutobutlerProvider < Provider
      DELIVERED_OK = 'SMS sent'
      DELIVER_EXCEPTION = 'Exception: %s'
      SMS_GATEWAY_ERROR = 'SMS Gateway Error Code: %s'
      FORMAT = 'UNICODE'

      def self.deliver(message)
        all_ok = false

        begin
          url = 'https://sms.autobutler.dk/api/v1/messages'

          body = {
            message: {
              to: message.phone_number,
              body: message.body
            }
          }

          if message.status_report_url.present?
            body[:callback_url] = message.status_report_url
          end

          response = RestClient.post(url, body, Authorization: "Bearer #{ENV['AUTOBUTLER_SMS_TOKEN']}")

          all_ok = response.code == 200
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
