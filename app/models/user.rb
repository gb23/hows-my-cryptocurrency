class User < ApplicationRecord
  has_many :transactions
  has_many :coins, :through => :transactions 
  has_many :wallets

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable  
  
  #when user is created, user gets wallets of all coin types
  after_create :give_wallets
  
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
  
  
  private

  def give_wallets
    Coin.all.each do |coin|
          self.wallets.create(name: coin.name, coin_id: coin.id )
    end
  end

end
