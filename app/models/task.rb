class Task < ApplicationRecord
  belongs_to :visit
  has_one :cap_result

  validates :status, :task_type, :visit, presence: true
  enum status: [:pending, :completed], _prefix: true
  enum task_type: [:cap, :rgrl, :rar], _prefix: true
  validate :validate_values

  private

  def validate_values
    return if valid_pending_values? && valid_completed_values?
    errors.add('invalid_task', 'Invalid completed_at for the status')
  end

  def valid_pending_values?
    status_pending? ? completed_at.blank? : true
  end

  def valid_completed_values?
    status_completed? ? completed_at.present? && valid_result_values? : true
  end

  def valid_result_values?
    cap_valid_values? && rar_valid_values? && rgrl_valid_values?
  end

  def rar_valid_values?
    # TODO
    task_type_rar? ? true : true
  end

  def rgrl_valid_values?
    # TODO
    task_type_rgrl? ? true : true
  end

  def cap_valid_values?
    task_type_cap? ? cap_result.present? && cap_result.valid_result? : true
  end

  def complete

  end

end
