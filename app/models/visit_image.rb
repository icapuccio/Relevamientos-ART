class VisitImage < ApplicationRecord
  belongs_to :visit
  validates :url_image, :visit, presence: true
end
