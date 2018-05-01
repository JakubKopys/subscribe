# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/application_form'

RSpec.describe Subscriptions::CreateForm, type: :model do
  it_behaves_like 'application_form'

  it { is_expected.to validate_presence_of :credit_card_number }
  it { is_expected.to validate_presence_of :cardholder_name }
  it { is_expected.to validate_presence_of :card_cvv }
  it { is_expected.to validate_presence_of :expiration_year }
  it { is_expected.to validate_presence_of :expiration_month }

  it 'validates credit card number' do
    invalid_number = 'foobar'
    form = described_class.new credit_card_number: invalid_number

    expect(form.valid?).to be false
    error_message = form.errors.messages[:credit_card_number].first
    expect(error_message).to eq 'is invalid'
  end
end
