class CapResult < ApplicationRecord
  # Associations
  belongs_to :task
  has_many :cap_employees
  validates :topic, :attendees_count, :task, presence: true

  def valid_result?
    attendees_count != 0 && (attendees_count.eql?cap_employees.size)
  end
end
