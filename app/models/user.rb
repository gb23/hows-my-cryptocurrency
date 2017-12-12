class User < ApplicationRecord
  has_many :transactions
  has_many :coins, :through => :transactions 
  has_many :wallets

  validates :name, presence: true
  validates :email, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook] 
  
  #when user is created, user gets wallets of BTC, LTC, ETH
  after_create :give_wallets

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end
  
  def update_numbers
    final_adjusted = 0
    final_unadjusted = 0
    final_money_in = 0
    self.wallets.each do |wallet| 
      wallet.get_and_save_current_price 
      wallet.update_wallet_with_coin_value
      final_adjusted += wallet.net_adjusted
      final_unadjusted +=wallet.net_unadjusted
      final_money_in += wallet.money_in
    end

    self.money_in = final_money_in
    self.net_adjusted = final_adjusted
    self.net_unadjusted = final_unadjusted
    self.save
  end

  def allCoinOptions
    #Wallet.where(["user_id = ? and coin_id = ?", self.user_id, self.coin_id]).first
    htmlOptions = ""
    self.wallets.each do |wallet|
      if Coin.all.detect{ |coin| coin.name == wallet.name}
        htmlOptions += "<option value='#{Coin.all.detect{ |coin| coin.name == wallet.name}.id}'>#{wallet.name}</option>"
      end
    end
    htmlOptions.html_safe
    #<%# <option value="1">Ethereum</option>
    #<option value="2">Bitcoin</option>
    #<option value="3">Litecoin</option> %>
  end

  private

  def give_wallets
    Coin.all.each do |coin|
          self.wallets.create(name: coin.name, coin_id: coin.id ) if big_3?(coin)
    end
  end

end
