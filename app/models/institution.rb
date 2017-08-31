class Institution < ApplicationRecord
  has_many :visits
  validates :name, :address, :city, :province, :number, :surface, :workers_count, :cuit, :activity,
            :institutions_count, :contract, :postal_code, :phone_number, presence: true
end
