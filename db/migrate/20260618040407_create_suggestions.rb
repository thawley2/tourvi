class CreateSuggestions < ActiveRecord::Migration[8.1]
  def change
    create_table :suggestions do |t|
      t.references :tour, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.string :address, null: false
      t.string :city
      t.integer :beds
      t.integer :baths
      t.string :price
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
