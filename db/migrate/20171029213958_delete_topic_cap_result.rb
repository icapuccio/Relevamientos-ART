class DeleteTopicCapResult < ActiveRecord::Migration[5.0]
  def change
    remove_column :cap_results, :topic
  end
end
