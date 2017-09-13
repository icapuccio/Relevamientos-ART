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
    return unless status_pending? && user.present? && user.role_preventor?
    self.status = 'assigned'
    self.user = user
    self.to_visit_on = Date.tomorrow
  end

  def revert_assignment
    return unless status_assigned?
    self.status = 'pending'
    self.user = nil
    self.to_visit_on = nil

  def finished?
    status_completed?
  end

  private

  def validate_values
    return if valid_pending_values? && valid_completed_values? && valid_assigned_values?
    errors.add('invalid_visit', "Invalid values for the status: #{status}")
  end

  def valid_pending_values?
    status_pending? ? user.blank? && to_visit_on.blank? : user.present? && to_visit_on.present?
  end

  def valid_completed_values?
    status_completed? ? completed_at.present? : completed_at.blank?
  end

  def valid_assigned_values?
    status_assigned? ? to_visit_on.present? && user.zone.eql?(institution.zone) : true
  end
end
