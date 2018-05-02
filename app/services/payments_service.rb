# frozen_string_literal: true

require 'subscriptions/payment_api'

class PaymentsService
  class FailedPaymentError < ::StandardError
    def initialize(message)
      super message
    end
  end

  def self.call(subscription:)
    new(subscription).call
  end

  def call
    response = Subscriptions::PaymentApi.make_payment @subscription

    return service_unavailable_failure unless response

    if response.fetch('paid')
      ServiceResult.new
    else
      insufficient_funds_faiure
    end
  end

  private

  def initialize(subscription)
    @subscription = subscription
  end

  def service_unavailable_failure
    payment_failure message: 'Service Unavailable'
  end

  def insufficient_funds_faiure
    payment_failure message: 'Insufficient funds'
  end

  def payment_failure(message:)
    error = FailedPaymentError.new message
    ServiceResult.new error: error
  end
end
