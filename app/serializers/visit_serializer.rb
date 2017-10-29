class VisitSerializer < ActiveModel::Serializer
  attributes :id, :status, :priority, :to_visit_on, :institution_id, :institution_name,
             :completed_at, :observations, :tasks

  def institution_name
    object.institution.name.capitalize
  end

  def status
    object.status_before_type_cast
  end

  def tasks
    object.tasks.map do |task|
      TaskSerializer.new(task)
    end
  end
end
