class DeleteTopicRarResults < ActiveRecord::Migration[5.0]
  def change
    remove_column :rar_results, :topic
  end
end
