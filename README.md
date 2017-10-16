# Rails Cryptocurrency Analysis Web App

This financial tracking app provides a database and web interface for users to:
* Create an account which stores transaction data for cryptocurrency purchases.
* Transaction calculations are performed using the cryptocurrency's trading price.
* For transactions with Bitcoin, Ethereum, and Litecoin, calculations use realtime market pricing.
* Calculated financial stats include, total portfolio worth, portfolio and wallet USD lost/gained, total coins in wallet, total USD spent on wallet, total USD value of wallet.
* User is also able to input a theoretical trading price and see how this effects output of calculations.
* Web App analyzes coin popularity across all users and displays results.
* Each user can **ONLY** add/edit/view/delete transactions of his/her own account.  
* All transactions of a same cryptocurrency are automatically grouped into a wallet.
* All wallets are grouped into a portfolio.
* A user initially starts out with 3 wallets: Bitcoin, Ethereum, and Litecoin.
* A user can add more wallet types by simply creating a transaction with a new coin type.
* User log-in, log-out, and session security is handled with Devise [Devise](https://github.com/plataformatec/devise)
* User input is validated using Rails validation methods


This app was built with Ruby, extended with [Rake tasks](https://github.com/ruby/rake) for working with an SQL database using Rails,[ActiveRecord ORM](https://github.com/rails/rails/tree/master/activerecord). This app uses the [Coinbase API](https://developers.coinbase.com/api/v2) to get realtime market data for Ethereum, Bitcoin, and Litecoin.  Styling structure was provided by [Tachyons](https://tachyons.io). Omniauth login support is provided with [Omniauth](https://github.com/omniauth/omniauth).

## Usage
Fork this repository to your own account

https://github.com/gb23/hows-my-cryptocurrency

Then clone the repository to your local environment

git@github.com:gb23/hows-my-cryptocurrency.git

After forking and cloning the repo, run ```bundle install``` to install Ruby gem dependencies.

Then setup the database with ```rake db:migrate```.

You can start one of Rails supported servers using the ```rails s``` command and navigate to `localhost:3000` in your browser.


## Models
The Cryptocurrency Analysis database includes four main model classes: ```User, Transaction, Wallet, and Coin```

1. User:
```
  has_many :transactions
  has_many :coins, :through => :transactions 
  has_many :wallets
```
    Has attributes (some of which are):
    * Name
    * Email
    * Money In
    * Net unadjusted money
    * Net adjusted money

    * Provider (for Omniauth supported logins)
    * uid (for Omniauth supported logins)
    * Password (Secured with Devise)

2. Transaction (join table):
```
    belongs_to :coin, optional: true
    belongs_to :user
```
    Has attributes:
    * user_id
    * coin_id
    * money in
    * price per coin
    * quantity
    * created/updated at

3. Wallet
```
    belongs_to :coin
    belongs_to :user
```
    Has attributes:
    * name
    * user_id
    * coin_id
    * total_coins
    * money_in
    * net_unadjusted
    * net_adjusted
    * created/updated at
4. Coin   
```
    has_many :transactions
    has_many :wallets
    has_many :users, :through => :transactions
```
    Has attributes:
    * name
    * last_value
    * created/updated at
  

## Contributing

Bug reports and pull requests are welcome on GitHub at [How's My Cryptocurrency](https://github.com/gb23/hows-my-cryptocurrency).

## License

The app is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
