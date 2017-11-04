class Task < ApplicationRecord
  belongs_to :visit
  belongs_to :result, polymorphic: true

  validates :status, :task_type, :visit, presence: true
  enum status: [:pending, :completed], _prefix: true
  enum task_type: [:cap, :rgrl, :rar], _prefix: true
  validate :validate_pending_values, :validate_completed_values

  def complete(completed_at)
    # Test
    update_attributes!(status: 'completed', completed_at: completed_at)
  end

  def completed?
    status_completed?
  end

  private

  def validate_pending_values
    return unless status_pending? && completed_at.present?
    errors.add(:invalid, 'La tarea no puede tener fecha \
      de finalización si se encuentra pendiente')
  end

  def validate_completed_values
    return unless status_completed?
    errors.add(:base, 'La tarea completada debe tener fecha de finalización') unless
        completed_at.present?
    return errors.add(:base, 'La tarea completada debe tener un resultado') unless
        result.present?
    errors.add(:base, 'La tarea completada debe tener al menos un empleado') unless
        result.valid_result?
  end
end
