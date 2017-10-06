module ApplicationHelper
    def coin_distribution(user)
        htm = ""
        user.wallets.each do |wallet|
                htm += "<li> Total #{wallet.coin.name}: #{'%.4f' % wallet.total_coins} </li>"  
        end
        htm
    end
end
