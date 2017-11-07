class Visit < ApplicationRecord
  include Filterable

  belongs_to :user
  belongs_to :institution
  has_many :tasks, dependent: :destroy
  has_many :visit_images, dependent: :destroy
  has_many :visit_noises, dependent: :destroy

  validates :status, :priority, :institution, presence: true
  validate :validate_values, :validate_completed_tasks

  enum status: [:pending, :assigned, :in_process, :completed, :sent], _prefix: true

  scope :status, ->(status) { where status: status }
  scope :user_id, ->(user) { where user_id: user }
  scope :assignable, -> { where(status: :pending).or(where(status: :assigned)) }
  scope :not_finished, -> { where.not(status: :completed).where.not(status: :sent) }
  scope :completed, -> { where status: :completed }
  scope :finished, -> { where(status: :completed).or(where(status: :sent)) }

  def valid_for_assignment?(user)
    status_pending? && user.assignable?
  end

  def assign_to(user)
    return false unless valid_assignment?(user)
    self.status = 'assigned'
    self.user = user
    self.to_visit_on = Date.tomorrow
    save
  end

  def complete(params)
    create_noises(params[:noises])
    create_images(params[:images])
    update_attributes(status: 'completed', completed_at: date_format(params[:completed_at]),
                      observations: params[:observations])
  end

  def status_sent
    update_attributes!(status: 'sent')
  end

  def remove_assignment
    return unless status_assigned?
    self.status = 'pending'
    self.user = nil
    self.to_visit_on = nil
    save
  end

  def finished?
    status_completed?
  end

  def cap_task_related?
    tasks.cap.exists?
  end

  def rgrl_task_related?
    tasks.rgrl.exists?
  end

  def rar_task_related?
    tasks.rar.exists?
  end

  def create_tasks(tasks)
    tasks.each { |task| Task.create!(task_type: task['type'], visit: self) }
  end

  private

  def create_noises(noises)
    return unless noises.present?
    noises.each do |noise|
      VisitNoise.create!(description: noise[:description], decibels: noise[:decibels], visit: self)
    end
  end

  def create_images(images)
    return unless images.present?
    images.each do |image|
      VisitImage.create!(url_image: image[:url_cloud], visit: self)
    end
  end

  def date_format(date)
    Time.zone.parse(date)
  end

  def valid_assignment?(user)
    errors.add(:base, 'El usuario debe ser preventor') unless user.role_preventor?
    errors.add(:base, 'La visita debe estar en estado pendiente') unless status_pending?
    errors.add(:base, 'EL usuario y la visita deben tener la misma zona') unless
        valid_user_zone(user)
    !errors.present?
  end

  def validate_completed_tasks
    errors.add('error', 'La visita contiene tareas sin finalizar') if
      status_completed? && !all_tasks_completed?
  end

  def all_tasks_completed?
    tasks.reject(&:completed?).empty?
  end

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
    status_completed? || status_sent? ? completed_at.present? : completed_at.blank?
  end

  def valid_assigned_values?
    status_assigned? ? valid_assigned_values_fields? : true
  end

  def valid_assigned_values_fields?
    to_visit_on.present? && user.present? && valid_user_zone(user)
  end

  def valid_user_zone(user)
    user.zone.eql?(institution.zone)
  end
end
