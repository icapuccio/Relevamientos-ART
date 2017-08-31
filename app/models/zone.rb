class Zone < ApplicationRecord
  has_many :users
  has_many :institutions

  validates :name, presence: true

  before_destroy :check_zone_associations

  private

  def check_zone_associations
    return true if valid_to_destroy?
    if institutions.any?
      errors.add(:base, I18n.t('activerecord.errors.models.zone.institutions_related'))
    end
    errors.add(:base, I18n.t('activerecord.errors.models.zone.users_related')) if users.any?
    throw(:abort)
  end

  def valid_to_destroy?
    institutions.empty? && users.empty?
  end
end
