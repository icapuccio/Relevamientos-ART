class Worker < ApplicationRecord
  belongs_to :rar_result
  validates :name, :last_name, :cuil, :rar_result_id, presence: true
  has_many :risks
end
