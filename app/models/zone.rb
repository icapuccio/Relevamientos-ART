class Zone < ApplicationRecord
  has_many :users
  has_many :institutions
  validates :name, presence: true

  before_destroy :check_zone_with_institutions_or_users

  def check_zone_with_institutions_or_users
    return true if institutions.count.zero? && users.count.zero?
    errors.add(:base, 'No se puede eliminar una zona con usuarios e instituciones')
    throw(:abort)
  end
end
