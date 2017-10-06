module TransactionsHelper
    def wallet_coins(user)
        user.wallets.collect do |wallet|
            wallet.coin
        end.compact
    end

    def wallet_already_exists_for?(user, name)
        wallet_coins(user).find { |coin| coin.name == name}
    end

    def fill_nested_coin_name_for(transaction)
        if !transaction.coin_id.nil?
            "" 
        else
            transaction.coin.name
        end
        #return "" if selected from dropdown
        #return transaction.coin.name if  typed in
    end

    def fill_nested_coin_value_for(transaction)
        if !transaction.coin_id.nil?
            "0.0" 
        else
            transaction.coin.last_value
        end
    end
end
