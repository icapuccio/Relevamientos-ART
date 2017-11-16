class User < ApplicationRecord
  MAX_NUMBER_OF_VISITS = 5

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Associations
  has_many :visits
  belongs_to :zone

  # Validations
  validates :email, uniqueness: true
  validates :email, format: Devise.email_regexp
  validates :name, :last_name, :role, presence: true
  validate :complete_preventor_data

  # Geocoder
  # geocoded_by :address

  # Hooks

  # before_validation :geocode, if: :address_changed?
  before_validation :generate_password, on: :create, unless: :password_given?
  after_create :send_welcome_email
  # after_validation :coordinates_changed?
  after_create :create_admin_user, if: :role_admin?
  before_destroy :check_user_with_visits
  before_destroy :delete_admin_user, if: :role_admin?

  enum role: [:backoffice, :admin, :preventor], _prefix: true

  def full_name
    "#{name} #{last_name}"
  end

  def assigned_visits_count_for_tomorrow
    visits.assigned_for_tomorrow.count
  end

  def assignable?
    role_preventor? && visits.assigned_for_tomorrow.count < MAX_NUMBER_OF_VISITS
  end

  def more_not_finished_visits_than?(user)
    visits.assigned_for_tomorrow.count > user.visits.assigned_for_tomorrow.count
  end

  def assignable_for_visit?(visit)
    visit.status_pending? && assignable? && visit.institution.zone == zone
  end

  def self.assignable_for_visit(visit)
    User.select { |user| user.assignable_for_visit?(visit) }
  end

  def reset_password_instructions
    generated_password = Devise.friendly_token.first(8)
    update_attributes!(password: generated_password, password_confirmation: generated_password)
    WelcomeMailer.reset_password_send(self, generated_password).deliver
  end

  private

  def password_given?
    password.present?
  end

  def generate_password
    @generated_password = Devise.friendly_token.first(8)
    self.password = @generated_password
    self.password_confirmation = @generated_password
  end

  def send_welcome_email
    return if Rails.env.test?
    WelcomeMailer.welcome_send(self, @generated_password).deliver
  end

  def check_user_with_visits
    return true if visits.count.zero?
    errors.add(:base, I18n.t('activerecord.errors.models.user.visits_assigned'))
    throw(:abort)
  end

  def create_admin_user
    AdminUser.create!(email: email, password: password, password_confirmation: password)
  end

  def delete_admin_user
    AdminUser.find_by(email: email).destroy
  rescue => e
    Rails.logger.info "Cannot find/delete AdminUser for: #{email}. Error: #{e.inspect}"
  end

  def complete_preventor_data
    return unless role_preventor?
    return if complete_preventor_data?
    # errors.add(:latitude, :blank) if latitude.nil?
    # errors.add(:longitude, :blank) if longitude.nil?
    errors.add(:zone, :blank) if zone.nil?
  end

  def complete_preventor_data?
    latitude && longitude && zone
  end

  def coordinates_changed?
    return unless address_changed? && !latitude_changed? && !longitude_changed?
    errors.add(:address, 'no es una dirección válida')
  end
end
