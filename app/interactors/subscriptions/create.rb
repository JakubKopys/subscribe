# frozen_string_literal: true

require 'subscriptions/payment_api'

module Subscriptions
  class Create < ApplicationInteractor
    def call
      validate_form
      subscription = create_subscription

      context.result = { subscription_id: subscription.id }
      context.status = :created
    end

    private

    def validate_form
      form = CreateForm.new form_params
      stop form.errors, :unprocessable_entity unless form.validate
    end

    def form_params
      CreateForm::ATTRIBUTES.each_with_object({}) do |form_attribute, hash|
        hash[form_attribute] = context.public_send form_attribute
      end
    end

    def create_subscription
      Subscription.new(form_params).tap do |subscription|
        make_payment subscription: subscription
        subscription.save!
      end
    end

    def make_payment(subscription:)
      return if PaymentApi.make_payment subscription.attributes

      error = Error.new 'Insufficient funds'
      stop error, :unprocessable_entity
    end
  end
end
