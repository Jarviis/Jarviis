class IssueSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :state,
             :due_date, :parent_id, :created_at, :updated_at
  has_one :reporter
  has_one :assignee
end
