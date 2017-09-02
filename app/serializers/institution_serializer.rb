class InstitutionSerializer < ActiveModel::Serializer
  attributes :name, :cuit, :address, :city, :province, :number, :activity, :contract,
             :postal_code, :surface, :workers_count, :institutions_count, :phone_number, :zone_name

  def zone_name
    object.zone.name.capitalize
  end
end
