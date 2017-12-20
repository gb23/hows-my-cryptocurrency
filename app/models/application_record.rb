class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def supported_coin?(coin)
    coin.name == "Bitcoin" || coin.name == "Ethereum" || coin.name == "Litecoin" || coin.name == "Bitcoin Cash"
  end
end
