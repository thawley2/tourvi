class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :agent, null: false, foreign_key: true
      t.references :tour, null: true, foreign_key: true
      t.string :notif_type
      t.text :body
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
