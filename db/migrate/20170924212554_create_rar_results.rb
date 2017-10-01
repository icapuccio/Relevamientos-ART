class CreateRarResults < ActiveRecord::Migration[5.0]
  def change
    create_table :rar_results do |t|
      t.string :topic, null: false

      t.timestamps
    end
  end
end
