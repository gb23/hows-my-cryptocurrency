class NoteSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :comment, :transaction_id
  belongs_to :transaction
end
