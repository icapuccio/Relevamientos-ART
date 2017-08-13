class CreateVisits < ActiveRecord::Migration[5.0]
  def change
    create_table :visits do |t|
      t.references :user, foreign_key: true
      t.string :status,       null: false, default: 'pending'
      t.integer :priority, null: false, default: 0

      t.timestamps
    end
    add_index :visits, :status
  end
end
