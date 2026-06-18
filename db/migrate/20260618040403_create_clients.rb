class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.references :agent, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email
      t.string :phone
      t.text :notes
      t.string :stage, default: "Searching"
      t.string :budget
      t.string :pre_approved, default: "No"
      t.string :pre_approval_amount
      t.string :portal_token, null: false

      t.timestamps
    end

    add_index :clients, :portal_token, unique: true
  end
end
