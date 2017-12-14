class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :coin_id, :money_in, :price_per_coin, :quantity, :created_at, :updated_at
  has_many :notes

  def money_in
    "%0.2f" % object.money_in 
  end

  def quantity
    "%0.4f" % object.quantity
  end

 

end
