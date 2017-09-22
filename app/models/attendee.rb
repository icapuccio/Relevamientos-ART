class Attendee < ApplicationRecord
  belongs_to :cap_result
  validates :name, :last_name, :cuil, :cap_result_id, presence: true
end
