class RgrlResult < ApplicationRecord
  has_one :task, as: :result
  has_many :questions
  validates :task, presence: true

  def valid_result?
    questions.size.positive?
  end

  def questions_count
    questions.size
  end
end
