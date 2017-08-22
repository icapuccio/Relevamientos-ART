class Visit < ApplicationRecord
  include Filterable
  belongs_to :user
  enum status: [:pending, :assigned, :in_process, :completed], _prefix: true
  validates :status, :priority, presence: true
  scope :status, ->(status) { where status: status }
  scope :user_id, ->(user) { where user_id: user }
end
