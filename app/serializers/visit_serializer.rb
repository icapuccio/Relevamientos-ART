class VisitSerializer < ActiveModel::Serializer
  attributes :id, :status, :priority, :to_visit_on, :institution_id, :institution_name

  def institution_name
    object.institution.name.capitalize
  end
end
