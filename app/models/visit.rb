class Visit < ApplicationRecord
  include Filterable
  belongs_to :user
  belongs_to :institution
  enum status: [:pending, :assigned, :in_process, :completed], _prefix: true
  validates :status, :priority, :institution, presence: true
  scope :status, ->(status) { where status: status }
  scope :user_id, ->(user) { where user_id: user }
end
