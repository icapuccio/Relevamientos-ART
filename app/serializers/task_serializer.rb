class TaskSerializer < ActiveModel::Serializer
  attributes :id, :task_type, :completed_at, :visit_id, :result_type, :result_id,
             :completed_at, :status
  def status
    object.status_before_type_cast
  end

  def task_type
    object.task_type_before_type_cast
  end
end
