class AddUrlCloudToResults < ActiveRecord::Migration[5.0]
  def change
    Visit.destroy_all
    add_column :cap_results, :url_cloud, :string,       null: false
    add_column :rar_results, :url_cloud, :string,       null: false
    add_column :rgrl_results, :url_cloud, :string,       null: false
  end
end
