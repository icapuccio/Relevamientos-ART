class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_validation :generate_password, on: :create
  before_destroy :check_user_with_visits

  has_many :visits

  enum role: [:backoffice, :admin, :preventor], _prefix: true

  validates :email, uniqueness: true
  validates :name, :last_name, :role, presence: true

  # TODO: Eliminar el hardcodeo de password cuando se implemente el envio de mail
  def generate_password
    # generated_password = Devise.friendly_token.first(8)
    generated_password = '12345678'
    self.password = generated_password
    self.password_confirmation = generated_password
    # RegistrationMailer.welcome(user, generated_password).deliver
  end

  def check_user_with_visits
    return true if visits.count.zero?
    errors.add(:base, 'No se puede eliminar un Usuario con Visitas asignadas')
    throw(:abort)
  end
end
