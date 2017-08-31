class AddZoneReferenceToInstitution < ActiveRecord::Migration[5.0]
  def change
    Visit.destroy_all
    Institution.destroy_all
    add_reference :institutions, :zone, foreign_key: true, null: false
  end
end
