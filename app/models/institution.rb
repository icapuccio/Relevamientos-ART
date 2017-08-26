class Institution < ApplicationRecord
  belongs_to :visit
  validates :name, :address, :city, :province, :number, :surface, :workers_count,
            :institutions_count, presence: true
end
