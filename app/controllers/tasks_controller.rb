class TasksController < ApplicationController
  def complete
    return render json: { error: 'The task doesn\'t exist' }, status: :not_found if task.nil?
    task.create_result(params)
    render json: task, status: :ok
  rescue ActiveRecord::RecordInvalid => exception
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  private

  def task
    @task ||= Task.find(params[:task_id])
  end
end
