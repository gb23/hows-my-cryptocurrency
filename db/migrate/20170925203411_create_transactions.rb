class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :coin_id
      t.float :money_in, default: 0
      t.float :price_per_coin, default: 0
      t.float :quantity, default: 0

      t.timestamps
    end
  end
end
