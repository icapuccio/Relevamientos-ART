class RarResult < ApplicationRecord
  has_one :task, as: :result
  has_many :workers
  validates :task, presence: true

  def valid_result?
    workers.size.positive?
  end

  def working_men_count
    workers.size
  end
end
