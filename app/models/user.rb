class User < ApplicationRecord
    validates :name, presence: true
    validates :usd, presence: true
    validates :btc, presence: true
end
