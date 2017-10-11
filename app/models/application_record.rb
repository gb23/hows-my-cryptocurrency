class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def big_3?(coin)
    coin.name == "Bitcoin" || coin.name == "Ethereum" || coin.name == "Litecoin"
  end
end
