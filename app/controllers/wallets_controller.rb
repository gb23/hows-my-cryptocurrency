class WalletsController < ApplicationController
    before_action :find_wallet, only: [:show]

    def index
        @wallets = current_user.wallets
        
    end

    def show
        if !authenticate(@wallet)
            redirect_to user_wallets_path(current_user), notice: "Only your own wallets are viewable."
        end
        @wallet.lookup_current_price
        # @wallet.coin.last_value = PriceScraper.send("get_#{@wallet.coin.name.downcase}_price")
        # @wallet.coin.save
        @wallet.update_wallet_with_coin_value

    end

   

    private

    def find_wallet
        @wallet = Wallet.find(params[:id])
    end

    def authenticate(wallet)
        current_user.wallets.find do |w|
            w.id == wallet.id 
        end
    end
end
