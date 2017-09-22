class CreateCapResults < ActiveRecord::Migration[5.0]
  def change
    create_table :cap_results do |t|
      t.string :topic, null: false
      t.string :used_materials
      t.string :coordinators
      t.string :delivered_materials

      t.timestamps
    end
  end
end
