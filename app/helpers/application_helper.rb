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

    def percent_format(amount)
        amount = string_to_float(amount)
        sign = find_sign(amount)
        display_amount = add_comma_to_number(amount)
        apply_color(amount, display_amount, sign)
    end

    def format_dollar_amount_of (amount, color) 
        
        amount = string_to_float(amount)
        
        display_amount = add_comma_to_number(amount)

        if color.empty?
            "<span> $#{display_amount} </span>".html_safe 
        else
            apply_color(amount, display_amount)
        end
    end

    def string_to_float(amount)
        amount.to_f if amount.instance_of?(String)
    end

    def add_comma_to_number(amount)
        number_with_delimiter(('%.2f' % amount), :delimiter => ',')
    end

    def apply_color(amount, display_amount, sign='$')
        if amount > 0
            "<span class='green animate-reveal animate-first'> #{sign}#{display_amount} </span>".html_safe 
        elsif amount < 0
            "<span class='red animate-reveal animate-first'> #{sign}#{display_amount} </span>".html_safe 
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

    def find_sign(amount)
        '+'  if amount > 0
    end
end
