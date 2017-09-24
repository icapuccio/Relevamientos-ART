class Risk < ApplicationRecord
  belongs_to :worker
  validates :description, :worker_id, presence: true
end
