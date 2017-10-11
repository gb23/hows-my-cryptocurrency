class Transaction < ApplicationRecord
    belongs_to :coin, optional: true
    belongs_to :user

    before_save :calculate_quantity
    after_save  :tell_wallet, :tell_user

    validates :coin_id, presence: true, if: :no_user_input_coin?
    validates :money_in, numericality: {greater_than: 0}
    validates :price_per_coin, numericality: {greater_than: 0}


    def user_input= transaction_params
        @transaction_params = transaction_params
    end
    def no_user_input_coin?
        @transaction_params ? @transaction_params[:coin_attributes][:name].empty? : true 
    end

    def coin_attributes=(coin_attributes)
        coin_attributes.each do |coin_attribute| 
            if !coin_attribute[1].empty? 

                if coin_attribute[0] == "name"
                    coin_attribute[1] = coin_attribute[1].humanize
    
                    if !Coin.find_by(name: coin_attribute[1])

                        coin = Coin.new(name: coin_attribute[1])
                        self.coin = coin    
                    else
                        coin = Coin.find_by(name: coin_attribute[1])
                        self.coin = coin
                    end

                elsif coin_attribute[0] == "last_value" && coin_attribute[1] != "0.0"
                    self.coin = Coin.new if self.coin.nil?
                    self.coin.last_value = coin_attribute[1] 
                end
            end
        end
    end

    def init_coin
        self.coin = Coin.new 
        self.coin.name = @transaction_params[:coin_attributes][:name]
        self.coin.last_value = @transaction_params[:coin_attributes][:last_value]
    end

    def did_user_not_type_in_name?
        @transaction_params[:coin_attributes][:name].empty?
    end

    def did_user_not_select_name?
        @transaction_params[:coin_id].empty?
    end

    def typed_in_coin_name
        @transaction_params[:coin_attributes][:name].humanize.strip
    end

    def typed_in_last_value
        @transaction_params[:coin_attributes][:last_value]
    end

    def user_type_in_name_and_no_wallet_exits_yet(current_user)
        !self.did_user_not_type_in_name? && !self.wallet_already_exists_for?(current_user, self.typed_in_coin_name)
    end

    def wallet_coins(user)
        user.wallets.collect do |wallet|
            wallet.coin
        end.compact
    end

    def wallet_already_exists_for?(user, name)
        self.wallet_coins(user).find { |coin| coin.name.humanize == name}
    end

    def wallet_last_or_find_for(current_user)
        if self.user_type_in_name_and_no_wallet_exits_yet(current_user)
            wallet = current_user.wallets.last
        else 
            wallet = current_user.wallets.find_by(name: self.coin.name)
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
