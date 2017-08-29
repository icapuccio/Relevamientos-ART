class
CreateZones < ActiveRecord::Migration[5.0]
  def change
    create_table :zones do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
