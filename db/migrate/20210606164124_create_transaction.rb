class CreateTransaction < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.string :purchase_currency
      t.decimal :usd, precision: 10, scale: 2
      t.decimal :btc, precision: 10, scale: 8
      t.string :exchangeRate
      t.integer :user
      t.timestamps
    end
  end
end
