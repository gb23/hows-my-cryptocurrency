class Note < ApplicationRecord
    belongs_to :tx, foreign_key: 'transaction_id', class_name: 'Transaction'
end