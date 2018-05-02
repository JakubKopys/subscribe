# frozen_string_literal: true

module Subscriptions
  class ListSerializer < ActiveModel::Serializer
    attributes :id, :cardholder_name, :created_at, :next_billing_date

    def next_billing_date
      created_at = subscription.created_at
      current_month = Time.current.month

      if Time.current.day >= created_at.day
        created_at.change(month: current_month + 1)
      else
        created_at.change(month: current_month)
      end
    end

    private

    def subscription
      object
    end
  end
end
