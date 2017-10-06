
class CoinbaseApi
    
    
    def self.get_bitcoin_price
        trade_hash = Coinbase::Exchange::Client.new("", "", "", product_id: "BTC-USD")
        extract_price_from(trade_hash)
    end

    def self.get_ethereum_price
        trade_hash = Coinbase::Exchange::Client.new("", "", "", product_id: "ETH-USD")
        extract_price_from(trade_hash)
    end

    def self.get_litecoin_price
        trade_hash = Coinbase::Exchange::Client.new("", "", "", product_id: "LTC-USD") 
        extract_price_from(trade_hash)
    end

    
    private
    def self.extract_price_from(trade_hash)
        trade_hash.last_trade.price.to_f
    end

  
end