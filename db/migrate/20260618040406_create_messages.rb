class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :tour, null: false, foreign_key: true
      t.string :sender_type, null: false
      t.integer :sender_id, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
