class IssueSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :assignee_id, :state,
             :due_date, :parent_id, :created_at, :updated_at
end
