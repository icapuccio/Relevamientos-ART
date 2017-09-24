class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :category, null: false
      t.string :description, null: false
      t.string :answer, null: false
      t.references :rgrl_result, foreign_key: true, null: false
      t.timestamps
    end
  end
end
