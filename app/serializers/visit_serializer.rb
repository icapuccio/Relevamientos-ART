class VisitSerializer < ActiveModel::Serializer
  attributes :id, :status, :priority
  has_one :user, serializer: UserSerializer
end
