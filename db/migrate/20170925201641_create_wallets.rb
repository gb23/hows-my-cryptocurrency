class CreateWallets < ActiveRecord::Migration[5.1]
  def change
    create_table :wallets do |t|
      t.string :name
      t.integer :user_id
      t.integer :coin_id
      t.float :total_coins, default: 0
      t.float :money_in, default: 0.00
      t.float :net_unadjusted, default: 0.00
      t.float :net_adjusted, default: 0.00

      t.timestamps
    end
  end
end
