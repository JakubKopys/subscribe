# frozen_string_literal: true

require 'rest-client'

module Subscriptions
  module PaymentApi
    extend self

    API_URL = 'http://localhost:4567/validate'
    REQUEST_TIMEOUT = 10

    def make_payment(params)
      response = send_request
      success? response
    end

    private

    def send_request
      RestClient::Request.execute method: :get,
                                  url: API_URL,
                                  user: Rails.application.secrets.payment_username,
                                  password: Rails.application.secrets.payment_password,
                                  read_timeout: REQUEST_TIMEOUT

    rescue RestClient::RequestTimeout
      send_request
    rescue RestClient::ServiceUnavailable => error
      return error.response
    end

    def success?(response)
      response.code >= 200 && response.code < 300
    end
  end
end
