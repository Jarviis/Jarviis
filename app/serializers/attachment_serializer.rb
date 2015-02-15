class AttachmentSerializer < ActiveModel::Serializer
  attributes :id
  attributes :url
  attributes :image?
  attributes :versions

  delegate :image?, to: :object
  delegate :versions, to: :object
  delegate :url, to: :object
end
