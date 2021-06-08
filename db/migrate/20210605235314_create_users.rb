class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.decimal :usd, precision: 10, scale: 2
      t.decimal :btc, precision: 10, scale: 8

      t.timestamps
    end
  end
end
