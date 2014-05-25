module Searchable::Issue
  extend ActiveSupport::Concern

  included do
    include ::Elasticsearch::Model
    include ::Elasticsearch::Model::Callbacks

    settings index: { number_of_shards: 1 } do
      mappings dynamic: 'false' do
        indexes :id, type: "integer"
        indexes :assignee_id, type: "integer"
        indexes :assignee_name, boost: 10
        indexes :assignee_username, boost: 20
        indexes :reporter_id, type: "integer"
        indexes :reporter_name, boost: 10
        indexes :reporter_username, boost: 20
        indexes :name
        indexes :username
        indexes :state, type: "integer"
        indexes :description
        indexes :created_at, type: "date"
        indexes :updated_at, type: "date"
        indexes :due_date, type: "date"
      end
    end
  end
end
