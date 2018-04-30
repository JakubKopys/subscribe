# frozen_string_literal: true

module Api
  module V1
    class SubscriptionsController < ApplicationController
      def index
        raise NotImplementedError
      end

      def create
        respond_with interactor: Subscriptions::Create.call(create_params)
      end


      private

      def create_params
        params.permit :card_cvv, :cardholder_name, :credit_card_number, :expiration_year,
                      :expiration_month
      end
    end
  end
end
