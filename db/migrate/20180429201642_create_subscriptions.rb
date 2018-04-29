class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.string :cardholder_name,    null: false
      t.string :card_cvv,           null: false
      t.string :credit_card_number, null: false
      t.integer :expiration_month,  null: false, limit: 2
      t.integer :expiration_year,   null: false, limit: 2

      t.timestamps null: false
    end
  end
end
