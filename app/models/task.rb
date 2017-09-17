class Task < ApplicationRecord
  belongs_to :visit
  has_one :cap_result

  validates :status, :task_type, :visit, presence: true
  enum status: [:pending, :completed], _prefix: true
  enum task_type: [:cap, :rgrl, :rar], _prefix: true
  validate :validate_pending_values, :validate_completed_values

  def complete(completed_at)
    update_attributes!(status: 'completed', completed_at: completed_at)
  end

  private

  def validate_pending_values
    return unless status_pending?
    return if completed_at.blank?
    errors.add(:invalid, 'La tarea no puede tener fecha \
      de finalizada si esta en estado pendiente')
  end

  def validate_completed_values
    return unless status_completed?
    errors.add(:invalid, 'La tarea completada debe tener fecha de finalización') unless
      completed_at.present?
    cap_valid_values
    rar_valid_values
    rgrl_valid_values
  end

  def rar_valid_values
    return unless task_type_rar?
  end

  def rgrl_valid_values
    return unless task_type_rgrl?
  end

  def cap_valid_values
    return unless task_type_cap?
    return errors.add(:invalid, 'La tarea completada debe tener un resultado') unless
      cap_result.present?
    errors.add(:invalid, 'La tarea completada debe tener al menos un empleado') unless
      cap_result.valid_result?
  end
end
