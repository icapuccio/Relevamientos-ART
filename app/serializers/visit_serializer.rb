class VisitSerializer < ActiveModel::Serializer
  has_many :tasks
  attributes :id, :status, :priority, :to_visit_on, :institution_id, :institution_name,
             :completed_at, :observations

  def institution_name
    object.institution.name.capitalize
  end

  def status
    object.status_before_type_cast
  end
end
