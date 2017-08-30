class Visit < ApplicationRecord
  include Filterable
  belongs_to :user
  enum status: [:pending, :assigned, :in_process, :completed], _prefix: true
  validates :status, :priority, presence: true
  scope :status, ->(status) { where status: status }
  scope :user_id, ->(user) { where user_id: user }

  validate :validate_values

  def validate_values
    return if valid_values
    errors.add('invalid_visit', 'Invalid user or visit_date for the status')
  end

  def valid_values
    status == 'pending' ? user_id.nil? && to_visit_on.nil? : user_id.presence && !to_visit_on.nil?
  end
end
