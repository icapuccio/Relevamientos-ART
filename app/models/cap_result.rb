class CapResult < ApplicationRecord
  has_one :task, as: :result
  has_many :attendees
  validates :topic, :task, presence: true

  def valid_result?
    attendees.size.positive?
  end

  def attendees_count
    attendees.size
  end
end
