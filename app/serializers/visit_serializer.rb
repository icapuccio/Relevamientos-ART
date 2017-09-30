class VisitSerializer < ActiveModel::Serializer
  attributes :id, :status, :priority, :to_visit_on, :institution_id, :institution_name,
             :completed_at, :observations

  def institution_name
    object.institution.name.capitalize
  end

  def status
    object.status.to_i
  end
end
