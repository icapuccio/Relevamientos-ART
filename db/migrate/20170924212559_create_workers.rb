class CreateWorkers < ActiveRecord::Migration[5.0]
  def change
    create_table :workers do |t|
      t.string :name, null: false
      t.string :last_name, null: false
      t.string :cuil, null: false
      t.string :sector
      t.date :checked_in_on
      t.date :exposed_from_at
      t.date :exposed_until_at
      t.references :rar_result, foreign_key: true, null: false

      t.timestamps
    end
    add_index :workers, [:cuil, :rar_result_id], unique: true
  end
end
