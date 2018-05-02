FactoryBot.define do
  factory :subscription do
    credit_card_number '4111111111111111'
    cardholder_name 'John'
    card_cvv '123'
    expiration_year 30
    expiration_month 11
  end
end
