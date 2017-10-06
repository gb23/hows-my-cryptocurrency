class Transaction < ApplicationRecord
    belongs_to :coin, optional: true
    belongs_to :user

    before_save :calculate_quantity
    after_save  :tell_wallet, :tell_user

    validates :coin_id, presence: true, if: :no_user_input_coin?
    validates :money_in, numericality: {greater_than: 0}
    validates :price_per_coin, numericality: {greater_than: 0}

    #disable field if nothing inside of coin_attribute name

    #font awesome, fa-edit
    #tachyons
    #bootstrap

    def user_input= transaction_params
        @transaction_params = transaction_params
    end
    def no_user_input_coin?
        @transaction_params ? @transaction_params[:coin_attributes][:name].empty? : true #&& @transaction_params[:coin_attributes][:last_value] == "0.0"
    end

    def coin_attributes=(coin_attributes) #{"name"=>"", "last_value"=>"0.0"}
        coin_attributes.each do |coin_attribute|  #name => "xyz"               last_value => 0.0

            if !coin_attribute[1].empty? #&& coin_attribute[1] != 0.0

                if coin_attribute[0] == "name"
                    coin_attribute[1] = coin_attribute[1].humanize
    
                    if !Coin.find_by(name: coin_attribute[1])

                        coin = Coin.new(name: coin_attribute[1])
                        self.coin = coin

                        #self.user.wallets.build(name: coin_attribute[1], coin_id: coin.id )
    
                    else

                        coin = Coin.find_by(name: coin_attribute[1])
                        self.coin = coin
                       
                    end
                elsif coin_attribute[0] == "last_value" && coin_attribute[1] != "0.0"
                   
                    self.coin = Coin.new if self.coin.nil?
                    
                    self.coin.last_value = coin_attribute[1] 
                end
               # self.save
            end
        end
    end

    private

    def tell_user
        User.find(self.user_id).update_numbers
    end
    def calculate_quantity
        self.quantity = self.money_in / self.price_per_coin
    end


    def tell_wallet

       wallet = Wallet.where(["user_id = ? and coin_id = ?", self.user_id, self.coin_id]).first

       wallet.update_wallet_with(self)
    end

end
