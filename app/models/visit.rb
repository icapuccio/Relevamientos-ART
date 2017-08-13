class Visit < ApplicationRecord
  belongs_to :user
  enum status: [:pending, :assigned, :in_process, :completed], _prefix: true
  validates :status, :priority, presence: true
end
