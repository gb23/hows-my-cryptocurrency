class Wallet < ApplicationRecord
    belongs_to :coin
    belongs_to :user

    def update_wallet_with(tx)
        self.sum_coins(tx)
        self.sum_money_in(tx)
        self.calculate_unadjusted
        self.calculate_adjusted
        self.save
    end

    def update_wallet_with_coin_value
        #if self.coin.name == "Ethereum" || self.coin.name == "Bitcoin" || self.coin.name == "Litecoin" 
            self.calculate_unadjusted
            self.calculate_adjusted
            self.save
        #end
    end

    def sum_coins(tx)
        self.total_coins += tx.quantity if tx.coin == self.coin
    end

    def sum_money_in(tx)
        self.money_in += tx.money_in if tx.coin == self.coin
    end

    def calculate_unadjusted
        self.net_unadjusted = self.total_coins * self.coin.last_value 
    end

    def calculate_adjusted
        self.net_adjusted = self.net_unadjusted - self.money_in
    end

    def get_and_save_current_price 
        if self.coin.name == "Ethereum" || self.coin.name == "Bitcoin" || self.coin.name == "Litecoin" 
            self.coin.last_value = CoinbaseApi.send("get_#{self.coin.name.downcase}_price")
            self.coin.save
        end
    end

    def get_current_price
        if self.coin.name == "Ethereum" || self.coin.name == "Bitcoin" || self.coin.name == "Litecoin" 
            CoinbaseApi.send("get_#{self.coin.name.downcase}_price")
        end
    end
end
