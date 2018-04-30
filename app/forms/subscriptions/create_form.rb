# frozen_string_literal: true

module Subscriptions
  class CreateForm
    ATTRIBUTES = %i[credit_card_number cardholder_name card_cvv expiration_year
                    expiration_month].freeze

    attr_accessor(*ATTRIBUTES)
  end
end
