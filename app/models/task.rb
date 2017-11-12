class Task < ApplicationRecord
  belongs_to :visit
  belongs_to :result, polymorphic: true, dependent: :destroy

  validates :status, :task_type, :visit, presence: true
  enum status: [:pending, :completed], _prefix: true
  enum task_type: [:cap, :rgrl, :rar], _prefix: true
  validate :validate_pending_values, :validate_completed_values

  scope :rgrl, -> { where(task_type: :rgrl) }
  scope :cap, -> { where(task_type: :cap) }
  scope :rar, -> { where(task_type: :rar) }

  def complete(completed_at)
    update_attributes!(status: 'completed', completed_at: completed_at)
  end

  def completed?
    status_completed?
  end

  def create_result(params)
    ActiveRecord::Base.transaction do
      task_type_case(params)
      complete(date_format(params[:completed_at]))
    end
  end

  private

  def task_type_case(params)
    case task_type
    when 'rgrl'
      create_result_rgrl(params)
    when 'cap'
      create_result_cap(params)
    when 'rar'
      create_result_rar(params)
    else
      raise 'task_type does not exist'
    end
  end

  def create_result_rgrl(params)
    rgrl_result = RgrlResult.create!(url_cloud: params[:url_cloud], task: self)
    rgrl_result.create_questions(params[:questions])
  end

  def create_result_rar(params)
    rar_result = RarResult.create!(url_cloud: params[:url_cloud], task: self)
    rar_result.create_workers(params[:working_men])
  end

  def create_result_cap(params)
    cap_result = CapResult.create!(url_cloud: params[:url_cloud], contents: params[:contents],
                                   course_name: params[:course_name],
                                   methodology: params[:methodology], task: self)
    cap_result.create_attendees(params[:attendees])
  end

  def date_format(date)
    Time.zone.parse(date)
  end

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
