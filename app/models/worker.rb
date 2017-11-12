class Worker < ApplicationRecord
  belongs_to :rar_result
  validates :name, :last_name, :cuil, :rar_result_id, presence: true
  has_many :risks, dependent: :destroy

  def create_risks(risks)
    risks.each do |risk|
      Risk.create!(description: risk[:description], worker: self)
    end
  end
end
