class IssueSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :state,
             :due_date, :created_at, :updated_at,
             :parent

  has_one :reporter
  has_one :assignee
  has_many :children, serializer: ChildrenSerializer, include: true
  has_one :parent, serializer: ChildrenSerializer, include: true
  has_many :attachments, serializer: AttachmentSerializer, include: true
end
