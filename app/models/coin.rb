class Coin < ApplicationRecord
    has_many :transactions
    has_many :wallets
    has_many :users, :through => :transactions

    validates :name, presence: { message: "Coin name must be valid" }
    validates :last_value, numericality: {greater_than: 0, message: "Current trading price must be greater than 0"}
    


end
