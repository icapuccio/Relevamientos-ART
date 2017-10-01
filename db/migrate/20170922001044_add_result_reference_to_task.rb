class AddResultReferenceToTask < ActiveRecord::Migration[5.0]
  def up
    change_table :tasks do |t|
      t.references :result, polymorphic: true
    end
  end
  def down
    change_table :tasks do |t|
      t.remove_references :result, polymorphic: true
    end
  end
end
