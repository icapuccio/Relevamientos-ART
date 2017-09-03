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

  private

  def validate_values
    return if valid_pending_values? && valid_completed_values?
    errors.add('invalid_visit', 'Invalid user or visit_date for the status')
  end

  def valid_pending_values?
    status_pending? ? user.blank? && to_visit_on.blank? : user.present? && to_visit_on.present?
  end

  def valid_completed_values?
    status_completed? ? completed_at.present? : completed_at.blank?
  end
end
