class VisitSerializer < ActiveModel::Serializer
  attributes :id, :status, :priority, :to_visit_on, :institution_id
end
