class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :coin_id, :money_in, :price_per_coin, :quantity, :created_at, :updated_at
  has_many :notes
end
