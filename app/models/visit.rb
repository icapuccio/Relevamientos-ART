class Visit < ApplicationRecord
  belongs_to :user
  enum status: { pending: 'pending', assigned: 'assigned',
                 in_process: 'in process', completed: 'completed' }
  validates :status, :priority, presence: true

  def assign_to(user_id)
    self.user = user_id
    self.status = status.assigned
  end
end
