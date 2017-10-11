module ApplicationHelper
    def coin_distribution(user)
        htm = ""
        user.wallets.each do |wallet|
            if wallet == user.wallets[user.wallets.size - 1]
                htm += "<li class='ph3 pv2'> Total #{wallet.coin.name}: #{'%.4f' % wallet.total_coins} </li>"  
            else
                htm += "<li class='ph3 pv2 bb b--light-silver'> Total #{wallet.coin.name}: #{'%.4f' % wallet.total_coins} </li>"                  
            end
        end
        htm.html_safe 
    end

    def format_dollar_amount_of (amount, color) 
        if amount.instance_of?(String)
            amount = amount.to_f
        end
        display_amount = number_with_delimiter(('%.2f' % amount), :delimiter => ',')
        if color.empty?
            "<span> $#{display_amount} </span>".html_safe 
        else
            apply_color(amount, display_amount)
        end
    end

    def apply_color(amount, display_amount)
        if amount > 0
            "<span class='green animate-reveal animate-first'> $#{display_amount} </span>".html_safe 
        elsif amount < 0
            "<span class='red animate-reveal animate-first'> $#{display_amount} </span>".html_safe 
        else
            "<span> $#{display_amount} </span>".html_safe 
        end
    end

    def list_item_open(params, transaction)
        if params[:action] != "show" || params[:controller] != "transactions"
            if current_user.transactions.last == transaction
                "<li class='list ph3 pv2'>".html_safe
            else
                "<li class='list ph3 pv2 bb b--light-silver'>".html_safe 
            end
        end
    end

    def list_item_close(params)
        "</li>".html_safe if params[:action] != "show" || params[:controller] != "transactions"
    end
end
