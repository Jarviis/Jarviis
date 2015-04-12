class Attachment < ActiveRecord::Base
  include ActiveModel::Serializers::JSON

  belongs_to :issue

  mount_uploader :filename, AttachmentUploader

  validates_presence_of :filename

  def versions
    image? ? [:thumbnail] : []
  end

  def image?
    !!(filename.file.content_type =~ /^image\/*/)
  end

  def url
    h = { main: filename.url }

    versions.each do |version|
      h[version] = filename.url(version)
    end

    h
  end
end
