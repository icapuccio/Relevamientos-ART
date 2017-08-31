class AddlatitudeToInstitution < ActiveRecord::Migration[5.0]

  def up
    add_column :institutions, :latitude, :float
    add_column :institutions, :longitude, :float
    Institution.update_all(latitude: 0, longitude: 0)
    change_column_null :institutions, :latitude, false
    change_column_null :institutions, :longitude, false
  end

  def down
    remove_column :institutions, :latitude
    remove_column :institutions, :longitude
  end
end