module Searchable::Issue
  extend ActiveSupport::Concern

  included do
    include ::Elasticsearch::Model
    include ::Elasticsearch::Model::Callbacks

    settings index: { number_of_shards: 1 } do
      mappings(dynamic: 'false',
        _all: { enabled: true },
        include_in_all: false) do
          indexes :assignee_id, type: "integer"
          indexes :assignee_name, analyzer: "standard", include_in_all: true
          indexes :assignee_username, include_in_all: true
          indexes :reporter_id, type: "integer"
          indexes :reporter_name, include_in_all: true
          indexes :reporter_username, include_in_all: true
          indexes :name, analyzer: "standard", include_in_all: true
          indexes :username, include_in_all: true
          indexes :state, type: "integer"
          indexes :description, analyzer: "standard", include_in_all: true
          indexes :created_at, type: "date"
          indexes :updated_at, type: "date"
          indexes :due_date, type: "date"
      end
    end
  end
end
