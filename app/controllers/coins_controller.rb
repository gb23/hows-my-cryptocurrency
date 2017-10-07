class CoinsController < ApplicationController
    def update
        @coin = Coin.find(params[:id])
        @coin.last_value = params[:coin][:last_value]
        @coin.save
        wallet = wallet_with_coin(@coin.name, current_user)
        wallet.update_wallet_with_coin_value
        redirect_to user_wallet_path(current_user, wallet)
    end

    private
    def wallet_with_coin(name, current_user)
        Wallet.where(["user_id = ? and name = ?", current_user.id, name]).first
    end
end
