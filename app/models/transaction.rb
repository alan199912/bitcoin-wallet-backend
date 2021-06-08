class Transaction < ApplicationRecord
    validates :purchase_currency, presence: true
    validates :btc, presence: false
    validates :usd, presence: true
    validates :exchangeRate, presence: true
    validates :user, presence: true
end
