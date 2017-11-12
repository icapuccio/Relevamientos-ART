class AddColumnsToInstitution < ActiveRecord::Migration[5.0]
  def change
    add_column :institutions, :contact, :string
    add_column :institutions, :email, :string
    add_column :institutions, :afip_cod, :string
    add_column :institutions, :ciiu, :string
  end
end
