class RenameCapResultFields < ActiveRecord::Migration[5.0]
  def change
    rename_column :cap_results, :used_materials, :contents
    rename_column :cap_results, :coordinators, :course_name
    rename_column :cap_results, :delivered_materials, :methodology
  end
end
