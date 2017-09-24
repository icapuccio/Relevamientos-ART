class Question < ApplicationRecord
  belongs_to :rgrl_result
  validates :description, :category, :answer, :rgrl_result_id, presence: true
end
