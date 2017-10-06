module WalletsHelper

    def empty? (wallet)
        wallet.total_coins == 0 ? true : false
    end
end
