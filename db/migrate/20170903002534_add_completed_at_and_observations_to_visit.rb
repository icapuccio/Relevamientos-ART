class AddCompletedAtAndObservationsToVisit < ActiveRecord::Migration[5.0]
  def change
    add_column :visits, :completed_at, :datetime
    add_column :visits, :observations, :string
  end
end
