class Institution < ApplicationRecord
  has_many :visits
  validates :name, :address, :city, :province, :number, :surface, :workers_count, :cuit, :activity,
            :institutions_count, :contract, :postal_code, :phone_number, :longitude, :latitude,
            presence: true
  before_destroy :check_institution_with_visits

  def check_institution_with_visits
    return true if visits.count.zero?
    errors.add(:base, 'No se puede eliminar una institucion con Visitas asignadas')
    throw(:abort)
  end
end
