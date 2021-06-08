class Bitcoin < ApplicationRecord
    validates :code
    validates :symbol
    validates :rate
    validates :description
    validates :rate_float
end