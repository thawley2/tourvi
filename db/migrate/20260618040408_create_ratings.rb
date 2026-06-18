class CreateRatings < ActiveRecord::Migration[8.1]
  def change
    create_table :ratings do |t|
      t.references :property, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.integer :value, null: false

      t.timestamps
    end

    add_index :ratings, [ :property_id, :client_id ], unique: true
  end
end
