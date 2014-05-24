class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :username, :teams
end
