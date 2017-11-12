class VisitNoise < ApplicationRecord
  belongs_to :visit
  validates :decibels, :description, :visit, presence: true

  def decibels_scaled
    de = decibels.to_f * 0.909
    de.to_s[0, 5]
  end
end
