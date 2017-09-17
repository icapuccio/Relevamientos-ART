class CreateCapResults < ActiveRecord::Migration[5.0]
  def change
    create_table :cap_results do |t|
      t.string :topic, null: false
      t.integer :attendees_count, null: false
      t.string :used_materials
      t.string :delivered_materials
      t.references :task, foreign_key: true, null: false

      t.timestamps
    end
  end
end
