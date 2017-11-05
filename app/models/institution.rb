class Institution < ApplicationRecord
  has_many :visits
  belongs_to :zone

  validates :name, :address, :city, :province, :number, :surface, :workers_count, :cuit, :activity,
            :institutions_count, :contract, :postal_code, :phone_number, :latitude, :longitude,
            :zone, presence: true

  # Geocoder
  # geocoded_by :address

  # Hooks
  before_validation :set_address, if: :address_attributes?
  # before_validation :geocode, if: :address_changed?
  after_validation :coordinates_changed?
  before_destroy :check_institution_with_visits

  private

  def check_institution_with_visits
    return true if visits.empty?
    errors.add(:base, I18n.t('activerecord.errors.models.institution.visits_related'))
    throw(:abort)
  end

  def set_address
    self.address = street + ' ' + number.to_s + ', ' + city
  end

  def address_attributes?
    street && number && city
  end

  def coordinates_changed?
    return unless address_changed? && !latitude_changed? && !longitude_changed?
    errors.add(:address, 'no es una dirección válida')
  end
end
