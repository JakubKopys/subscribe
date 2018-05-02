# frozen_string_literal: true

require 'rails_helper'
require 'support/helpers/payment_api_helper'

RSpec.describe Api::V1::SubscriptionsController, type: :request do
  describe 'GET #index' do
    context 'without pagination params' do
      it 'returns all subscriptions with next billing dates' do
        subscription = FactoryBot.create :subscription
        next_billing_date = subscription.created_at + 1.month

        get '/api/v1/subscriptions'

        expected_json_response = [
          {
            id: subscription.id,
            cardholder_name: subscription.cardholder_name,
            created_at: subscription.created_at,
            next_billing_date: next_billing_date
          }
        ].as_json

        json_response = JSON.parse response.body
        expect(response).to be_success
        expect(json_response).to eq expected_json_response
      end
    end

    context 'with pagination params' do
      it 'returns paginated subscriptions' do
        subscriptions = FactoryBot.create_list :subscription, 2
        first_subscription = subscriptions.first
        next_billing_date = first_subscription.created_at + 1.month

        page_params = { page: 2, per_page: 1 }
        get '/api/v1/subscriptions', params: page_params

        expected_json_response = [
          {
            id: first_subscription.id,
            cardholder_name: first_subscription.cardholder_name,
            created_at: first_subscription.created_at,
            next_billing_date: next_billing_date
          }
        ].as_json

        json_response = JSON.parse response.body
        expect(response).to be_success
        expect(json_response).to eq expected_json_response
      end
    end
  end

  describe 'POST #create' do
    include PaymentApiHelper

    context 'with invalid credit card number' do
      it 'is unprocessable and returns errors' do
        create_params = {
          credit_card_number: 'invalid credit card number',
          cardholder_name: 'foobar',
          card_cvv: '123',
          expiration_year: '30',
          expiration_month: '11'
        }

        expect do
          post '/api/v1/subscriptions', params: create_params
        end.not_to change(Subscription, :count)

        json_response = JSON.parse response.body
        expect(response).to be_unprocessable
        expect(json_response).to have_key 'errors'
      end
    end

    context 'when payment succeeds' do
      it 'is created and saves Subscription' do
        mock_success_payment_response

        create_params = FactoryBot.attributes_for :subscription

        expect do
          post '/api/v1/subscriptions', params: create_params
        end.to change(Subscription, :count).by 1

        json_response = JSON.parse response.body
        expect(response).to be_created
        expect(json_response).to have_key 'subscription_id'
      end
    end

    context 'when payment fails' do
      it 'is unprocessable and does not save Subscription' do
        mock_insufficient_funds_payment_response

        create_params = FactoryBot.attributes_for :subscription

        expect do
          post '/api/v1/subscriptions', params: create_params
        end.not_to change(Subscription, :count)

        json_response = JSON.parse response.body
        expect(response).to be_unprocessable
        expect(json_response['errors']).to eq 'Insufficient funds'
      end
    end

    context 'when payment api is unavailable' do
      it 'is unprocessable and does not save Subscription' do
        mock_service_unavailable_payment_response

        create_params = FactoryBot.attributes_for :subscription

        expect do
          post '/api/v1/subscriptions', params: create_params
        end.not_to change(Subscription, :count)

        json_response = JSON.parse response.body
        expect(response).to be_unprocessable
        expect(json_response['errors']).to eq 'Service Unavailable'
      end
    end
  end
end
