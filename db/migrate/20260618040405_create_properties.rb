class CreateProperties < ActiveRecord::Migration[8.1]
  def change
    create_table :properties do |t|
      t.references :tour, null: false, foreign_key: true
      t.string :address, null: false
      t.string :city
      t.integer :beds
      t.integer :baths
      t.string :price
      t.string :mls_id
      t.text :notes
      t.integer :position

      t.timestamps
    end
  end
end
