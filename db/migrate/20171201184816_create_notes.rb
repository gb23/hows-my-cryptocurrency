class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.integer :transaction_id
      t.string :comment

      t.timestamps
    end
  end
end
