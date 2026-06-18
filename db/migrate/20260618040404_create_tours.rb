class CreateTours < ActiveRecord::Migration[8.1]
  def change
    create_table :tours do |t|
      t.references :agent, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.string :name, null: false
      t.date :tour_date
      t.string :tour_time
      t.string :status, default: "draft"
      t.text :post_notes

      t.timestamps
    end
  end
end
