class CreateVisitNoises < ActiveRecord::Migration[5.0]
  def change
    create_table :visit_noises do |t|
      t.string :description , null: false
      t.string :decibels , null: false
      t.references :visit, foreign_key: true, null: false
      t.timestamps
    end
  end
end
