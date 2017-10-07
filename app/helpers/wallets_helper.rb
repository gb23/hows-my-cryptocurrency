module WalletsHelper

    def empty? (wallet)
        wallet.total_coins == 0 ? true : false
    end

    def wallet_for(current_user, name)
        Wallet.where(["user_id = ? and name = ?", current_user.id, name]).first
    end
end
