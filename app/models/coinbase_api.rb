class CoinbaseApi
    
    
    def self.get_bitcoin_price
        resp = Faraday.get 'https://api.coinbase.com/v2/prices/BTC-USD/spot'
        self.handleResponse(resp)       
    end

    def self.get_bitcoin_cash_price
        resp = Faraday.get 'https://api.coinbase.com/v2/prices/BCH-USD/spot'
        self.handleResponse(resp)   
    end

    def self.get_ethereum_price
        resp = Faraday.get 'https://api.coinbase.com/v2/prices/ETH-USD/spot'  
        self.handleResponse(resp) 
    end

    def self.get_litecoin_price
        resp = Faraday.get 'https://api.coinbase.com/v2/prices/LTC-USD/spot'
        self.handleResponse(resp) 
    end

    
    private
    def self.handleResponse(resp)
        if resp.status == 200
            extract_price_from(JSON.parse(resp.body));
        else
            raise "Error connecting to Coinbase.  Try again soon.  Just kidding, try again now!"
        end
    end
    def self.extract_price_from(trade_hash)
        trade_hash["data"]["amount"].to_f
    end

end