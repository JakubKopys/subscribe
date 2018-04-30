# frozen_string_literal: true

require 'rest-client'

module Subscriptions
  module PaymentApi
    extend self
    API_URL = 'http://localhost:4567/validate'

    def make_payment(params)
      response = send_request
      success? response
    end

    private

    def send_request
      headers = { authorization: 'Basic YmlsbGluZzpnYXRld2F5' }
      RestClient.get(API_URL, headers)
      # TODO: rescue unauthorized
      # TODO: set RestClient timeout
    rescue RestClient::RequestTimeout
      send_request
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end

    def success?(response)
      response.code >= 200 && response.code < 300
    end
  end
end
