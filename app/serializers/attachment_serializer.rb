class AttachmentSerializer < ActiveModel::Serializer
  attributes :id
  attributes :url
  attributes :versions
  attributes :type

  delegate :type, to: :object
  delegate :versions, to: :object
  delegate :url, to: :object
end
