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

    def create

        if params[:commit] == "Calculate With Theoretical Price"
            #using params user_id, you now have handle for all the wallets
            u = User.find(params[:user_id])
            w = u.wallets.find_by(name: params[:coin][:name])
            @wallet = Wallet.new(name: w.name, user_id: u.id, total_coins: w.total_coins, money_in: w.money_in, net_unadjusted: w.net_unadjusted, net_adjusted: w.net_adjusted )
            
            @wallet.coin = Coin.new(name: params[:coin][:name], last_value: params[:coin][:last_value])
        # transactions = Transaction.where(["user_id = ? and coin_id = ?", u.id, Coin.find_by(name: params[:coin][:name]).id]).to_a
            @wallet.calculate_unadjusted
            @wallet.calculate_adjusted
            render :show

        end

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
