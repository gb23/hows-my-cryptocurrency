module WalletsHelper

    def empty? (wallet)
        wallet.total_coins == 0 ? true : false
    end

    def wallet_for(current_user, name)
        Wallet.where(["user_id = ? and name = ?", current_user.id, name]).first
    end

    def wallet_list_item_open(current_user, wallet)
        if current_user.wallets.last == wallet
            "<li class='list ph3 pv2'>".html_safe
        else
            "<li class='list ph3 pv2 bb b--light-silver'>".html_safe 
        end
    end

    def big_3_coins_in?(wallet)
        wallet.coin.name == "Ethereum" || wallet.coin.name == "Bitcoin" || wallet.coin.name == "Litecoin"
    end
end


