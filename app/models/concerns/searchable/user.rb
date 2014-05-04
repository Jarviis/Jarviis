module Searchable::User
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings index: { number_of_shards: 1 } do
      mappings dynamic: 'false' do
        indexes :id, type: "integer"
        indexes :email, boost: 10
        indexes :name
        indexes :username, boost: 10
        indexes :created_at, type: "date"
        indexes :updated_at, type: "date"
      end
    end
  end
end
