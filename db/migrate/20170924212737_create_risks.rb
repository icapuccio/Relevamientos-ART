class CreateRisks < ActiveRecord::Migration[5.0]
  def change
    create_table :risks do |t|
      t.string :description
      t.references :worker, foreign_key: true, null: false

      t.timestamps
    end
  end
end
