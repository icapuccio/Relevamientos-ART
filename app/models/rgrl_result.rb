class RgrlResult < ApplicationRecord
  has_one :task, as: :result
  has_many :questions, dependent: :destroy
  validates :task, :url_cloud, presence: true

  def valid_result?
    questions.size.positive?
  end

  def questions_count
    questions.size
  end

  def create_questions(questions)
    questions.each do |question|
      Question.create!(description: question[:description], answer: question[:answer],
                       category: question[:category], rgrl_result: self)
    end
  end
end
