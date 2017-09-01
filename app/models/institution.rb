class Institution < ApplicationRecord
  has_many :visits
  belongs_to :zone

  validates :name, :address, :city, :province, :number, :surface, :workers_count, :cuit, :activity,
            :institutions_count, :contract, :postal_code, :phone_number, :longitude, :latitude,
            :zone, presence: true

  before_destroy :check_institution_with_visits

  private

  def check_institution_with_visits
    return true if visits.empty?
    errors.add(:base, I18n.t('activerecord.errors.models.institution.visits_related'))
    throw(:abort)
  end
end
