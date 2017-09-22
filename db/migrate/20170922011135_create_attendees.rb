class CreateAttendees < ActiveRecord::Migration[5.0]
  def change
    create_table :attendees do |t|
      t.string :name, null: false
      t.string :last_name, null: false
      t.string :cuil, null: false
      t.string :sector
      t.references :cap_result, foreign_key: true, null: false
      t.timestamps
    end
    add_index :attendees, [:cuil, :cap_result_id], unique: true
  end
end
