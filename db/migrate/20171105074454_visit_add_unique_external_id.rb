class VisitAddUniqueExternalId < ActiveRecord::Migration[5.0]
  def change
    add_index :visits, [:external_id], unique: true
  end
end
