module TransactionsHelper


    def fill_nested_coin_name_for(transaction)
        if !transaction.coin_id.nil?
            "" 
        else
            transaction.coin.name
        end
    end

    def fill_nested_coin_value_for(transaction)
        if !transaction.coin_id.nil?
            "0.00" 
        else
            transaction.coin.last_value
        end
    end

    def coin_errors_for?(transaction)
        transaction.coin.errors[:last_value].any?
    end
end
