class VisitAddExternalId < ActiveRecord::Migration[5.0]
  def up
    add_column :visits, :external_id, :integer
    Visit.destroy_all
    change_column_null :visits, :external_id, false
  end
  def down
    remove_column :visits, :external_id
  end
end
