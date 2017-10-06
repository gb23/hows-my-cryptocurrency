class CreateCoins < ActiveRecord::Migration[5.1]
  def change
    create_table :coins do |t|
      t.string :name
      t.float :last_value, default: 0

      t.timestamps
    end
  end
end
