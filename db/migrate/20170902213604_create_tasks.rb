class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.integer :task_type, null: false, default: 0
      t.string :status, null: false
      t.datetime :completed_at
      t.references :visit, foreign_key: true, null: false

      t.timestamps
    end
  end
end
