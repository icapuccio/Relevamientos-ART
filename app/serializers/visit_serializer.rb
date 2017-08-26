class VisitSerializer < ActiveModel::Serializer
  attributes :id, :status, :priority, :institution_id
end
