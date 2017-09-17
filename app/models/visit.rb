class Visit < ApplicationRecord
  include Filterable

  belongs_to :user
  belongs_to :institution
  has_many :tasks, dependent: :destroy

  validates :status, :priority, :institution, presence: true
  validate :validate_values

  enum status: [:pending, :assigned, :in_process, :completed], _prefix: true

  scope :status, ->(status) { where status: status }
  scope :user_id, ->(user) { where user_id: user }

  def assign_to(user)
    return unless valid_for_assignment?(user)
    self.status = 'assigned'
    self.user = user
    self.to_visit_on = Date.tomorrow
  end

  def valid_for_assignment?(user)
    status_pending? && user.present? && user.role_preventor?
  end

  def remove_assignment
    return unless status_assigned?
    self.status = 'pending'
    self.user = nil
    self.to_visit_on = nil
  end

  def finished?
    status_completed?
  end

  private

  def validate_values
    errors.add('Pending visit', 'Invalid values') unless valid_pending_values?
    errors.add('Completed visit', 'Invalid values') unless valid_completed_values?
    errors.add('Assigned visit', 'Invalid values') unless valid_assigned_values?
  end

  def complete_preventor_data
    return unless role_preventor?
    return if complete_preventor_data?
    errors.add(:latitude, :blank) if latitude.nil?
    errors.add(:longitude, :blank) if longitude.nil?
    errors.add(:zone, :blank) if zone.nil?
  end

  def valid_pending_values?
    status_pending? ? user.blank? && to_visit_on.blank? : user.present? && to_visit_on.present?
  end

  def valid_completed_values?
    status_completed? ? completed_at.present? : completed_at.blank?
  end

  def valid_assigned_values?
    status_assigned? ? valid_assigned_values_fields? : true
  end

  def valid_assigned_values_fields?
    to_visit_on.present? && user.present? && user.zone.eql?(institution.zone)
  end
end
