class WalletsController < ApplicationController
    before_action :find_wallet, only: [:show]

    def index
        @wallets = current_user.wallets
        
    end

    def show
        if !authenticate(@wallet)
            redirect_to user_wallets_path(current_user), notice: "Only your own wallets are viewable."
            return
        end
        @wallet.get_and_save_current_price
        @wallet.update_wallet_with_coin_value
    end

    def create
        if params[:commit] == "Calculate With Theoretical Price"
            u = User.find(params[:user_id])
            w = u.wallets.find_by(name: params[:coin][:name])
            @wallet = Wallet.new(name: w.name, user_id: u.id, total_coins: w.total_coins, money_in: w.money_in, net_unadjusted: w.net_unadjusted, net_adjusted: w.net_adjusted )
            
            @wallet.coin = Coin.new(name: params[:coin][:name], last_value: params[:coin][:last_value])

            @wallet.calculate_unadjusted
            @wallet.calculate_adjusted
            render :show
        end
    end

    private

    def find_wallet
        @wallet = Wallet.find_by(id: params[:id])
    end

    def authenticate(wallet)
        if wallet.nil?
            false
        else
            current_user.wallets.find do |w|
                w.id == wallet.id 
            end
        end
    end
end
