class Coin < ApplicationRecord
    has_many :transactions
    has_many :wallets
    has_many :users, :through => :transactions

    validates :name, presence: { message: "Coin name must be valid" }
    validates :last_value, numericality: {greater_than: 0, message: "Trading price must be greater than 0"}

    def self.most_transactions
        coin_hash = {}
        self.all.each do |coin|
            coin_hash[coin.name] =  coin.transactions.size
        end
        coin_hash.sort_by{|key, value| value}.reverse
    end
    
end
