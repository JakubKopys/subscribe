# frozen_string_literal: true

require 'subscriptions/payment_api'

module PaymentApiHelper
  def mock_insufficient_funds_payment_response
    insufficient_funds_response = {
      id: 'foobar',
      paid: false,
      failure_message: 'insufficient_funds'
    }.as_json

    mock_response json_response: insufficient_funds_response
  end

  def mock_success_payment_response
    success_response = {
      id: 'foobar',
      paid: true,
      failure_message: nil
    }.as_json

    mock_response json_response: success_response
  end

  def mock_service_unavailable_payment_response
    mock_response json_response: nil
  end

  private

  def mock_response(json_response:)
    expect(Subscriptions::PaymentApi).to receive(:make_payment)
                                     .and_return json_response
  end
end
