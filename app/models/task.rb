class Task < ApplicationRecord
  belongs_to :visit

  validates :status, :task_type, :visit, presence: true
  enum status: [:pending, :completed], _prefix: true
  enum task_type: [:cap, :rgrl, :rar], _prefix: true
  validate :validate_values

  def completed?
    status_completed?
  end

  private

  def validate_values
    return if valid_values?
    errors.add('invalid_task', 'Invalid completed_at for the status')
  end

  def valid_values?
    status_pending? ? completed_at.blank? : completed_at.present?
  end
end
