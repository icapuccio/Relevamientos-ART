class TasksController < ApplicationController
  def complete
    return render json: { error: 'The task doesn\'t exist' }, status: :not_found if task.nil?
    complete_process
    render json: task, status: :ok
  rescue ActiveRecord::RecordInvalid => exception
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def complete_process
    ActiveRecord::Base.transaction do
      task_type_case
      task.complete(date_format(params[:completed_at]))
    end
  end

  def task_type_case
    case task.task_type_before_type_cast
    when Task.task_types[:rgrl]
      create_result_rgrl
    when Task.task_types[:cap]
      create_result_cap
    when Task.task_types[:rar]
      create_result_rar
    else
      raise 'task_type does not exists'
    end
  end

  private

  def task
    @task ||= Task.find(params[:task_id])
  end

  def date_format(date)
    Time.zone.parse(date)
  end

  def create_result_rgrl
    rgrl_result = RgrlResult.create!(task: task)
    params[:questions].each do |question|
      Question.create!(description: question[:description], answer: question[:answer],
                       category: question[:category], rgrl_result: rgrl_result)
    end
  end

  def create_result_rar
    rar_result = RarResult.create!(task: task)
    params[:working_men].each do |w|
      create_worker(rar_result, w)
    end
  end

  def create_worker(rar_result, w)
    worker = Worker.create!(name: w[:name], last_name: w[:last_name], cuil: w[:cuil],
                            checked_in_on: date_format(w[:checked_in_on]),
                            exposed_from_at: date_format(w[:exposed_from_at]),
                            exposed_until_at: date_format(w[:exposed_until_at]),
                            sector: w[:sector], rar_result: rar_result)
    create_risks(w, worker)
  end

  def create_risks(w, worker)
    w[:risk_list].each do |risk|
      Risk.create!(description: risk[:description], worker: worker)
    end
  end

  def create_result_cap
    cap_result = CapResult.create!(task: task, topic: params[:course_name],
                                   contents: params[:contents], course_name: params[:course_name],
                                   methodology: params[:methodology])
    create_attendees(cap_result)
  end

  def create_attendees(cap_result)
    params[:attendees].each do |attendee|
      Attendee.create!(name: attendee[:name], last_name: attendee[:last_name],
                       cuil: attendee[:cuil], sector: attendee[:sector], cap_result: cap_result)
    end
  end
end
