class CapResult < ApplicationRecord
  # Associations
  belongs_to :task
  has_many :cap_employees
  validates :topic, :task, presence: true

  def valid_result?
    cap_employees.size.positive?
  end
end
