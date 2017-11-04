class VisitNoise < ApplicationRecord
  belongs_to :visit
  validates :decibels, :description, :visit, presence: true
end
