class VisitSerializer < ActiveModel::Serializer
  attributes :id, :status, :priority, :to_visit_on
end
