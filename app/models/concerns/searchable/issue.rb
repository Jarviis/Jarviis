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

  module ClassMethods

    # Search in the _all field with filters
    def global_search(keyword, operator="and", options={})

      query = {
        query: {
          filtered: {
            query: {
              match: {
                _all: {
                  query: keyword,
                  operator: operator
                }
              }
            },
            filter: {
              bool: {
                must: []
              }
            }
          }
        }
      }

      if options[:state].present?
        query[:query][:filtered][:filter][:bool][:must] <<
          { term: { state: options[:state] } }
      end

      if options[:assignee_id].present?
        query[:query][:filtered][:filter][:bool][:must] <<
          { term: { assignee_id: options[:assignee_id] } }
      end

      if options[:reporter_id].present?
        query[:query][:filtered][:filter][:bool][:must] <<
          { term: { reporter_id: options[:reporter_id] } }
      end

      __elasticsearch__.search(query)
    end
  end
end
