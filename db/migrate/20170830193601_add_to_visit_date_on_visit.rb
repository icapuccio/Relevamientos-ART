class AddToVisitDateOnVisit < ActiveRecord::Migration[5.0]
  def change
    add_column :visits, :to_visit_on, :date
  end
end
