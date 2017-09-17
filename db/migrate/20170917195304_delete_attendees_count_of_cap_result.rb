class DeleteAttendeesCountOfCapResult < ActiveRecord::Migration[5.0]
  def change
    remove_column :cap_results, :attendees_count, :integer
  end
end
