class SprintSerializer < ActiveModel::Serializer
  attributes :id, :name, :starttime, :endtime, :percentage, :created_at, :updated_at

  has_one :team
  has_many :issues
end
