class CapResult < ApplicationRecord
  has_one :task, as: :result
  has_many :attendees
  validates :methodology, :course_name, :contents, :task, presence: true

  def valid_result?
    attendees.size.positive?
  end

  def attendees_count
    attendees.size
  end

  def create_attendees(attendees)
    attendees.each do |attendee|
      Attendee.create!(name: attendee[:name], last_name: attendee[:last_name],
                       cuil: attendee[:cuil], sector: attendee[:sector], cap_result: self)
    end
  end
end
