class ChangeAddressOnInstitutions < ActiveRecord::Migration[5.0]
  def up
    add_column :institutions, :street, :string
    Institution.all.each do |institution|
      institution.street = institution.address
      institution.address = institution.street + ' ' + institution.number.to_s + ', ' + institution.city
      institution.save!
    end
    change_column_null :institutions, :street, false
  end

  def down
    Institution.all.each do |institution|
      institution.address = institution.street
      institution.save!
    end
    remove_column :institutions, :street
  end
end
