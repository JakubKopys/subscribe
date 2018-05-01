# frozen_string_literal: true

require 'credit_card_validations'

module Subscriptions
  class CreateForm < ApplicationForm
    ATTRIBUTES = %i[credit_card_number cardholder_name card_cvv expiration_year
                    expiration_month].freeze

    validates :credit_card_number, :cardholder_name, :card_cvv, :expiration_year,
              :expiration_year, presence: true
    validates :credit_card_number, credit_card_number: true

    attr_accessor(*ATTRIBUTES)
  end
end
