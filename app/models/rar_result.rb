class RarResult < ApplicationRecord
  has_one :task, as: :result
  has_many :workers, dependent: :destroy
  validates :task, :url_cloud, presence: true

  def valid_result?
    workers.size.positive?
  end

  def working_men_count
    workers.size
  end

  def create_workers(working_men)
    working_men.each do |incoming_worker|
      create_worker(incoming_worker)
    end
  end

  private

  def create_worker(incoming_worker)
    worker = Worker.create!(name: incoming_worker[:name], last_name: incoming_worker[:last_name],
                            cuil: incoming_worker[:cuil],
                            checked_in_on: date_format(incoming_worker[:checked_in_on]),
                            exposed_from_at: date_format(incoming_worker[:exposed_from_at]),
                            exposed_until_at: date_format(incoming_worker[:exposed_until_at]),
                            sector: incoming_worker[:sector], rar_result: self)
    worker.create_risks(incoming_worker[:risk_list])
  end

  def date_format(date)
    Time.zone.parse(date)
  end
end
