class AddAttributesToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :name, :string
    add_column :users, :last_name, :string
    User.reset_column_information
    User.update_all(name: 'update this', last_name: 'update_this')
    change_column_null :users, :name, false
    change_column_null :users, :last_name, false
    add_column :users, :role, :integer, null: false, default: 0
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
  end

  def down
    remove_column :users, :name
    remove_column :users, :last_name
    remove_column :users, :role
    remove_column :users, :latitude
    remove_column :users, :longitude
  end
end
