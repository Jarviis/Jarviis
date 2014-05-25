# encoding: utf-8
class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  include CarrierWave::MiniMagick

  storage :file

  process :set_content_type

  def store_dir
    "uploads/Issue/attachements/#{model.issue_id}"
  end

  version :thumbnail, if: :image? do
    process :resize_to_fill => [200, 200]
  end

  protected

  def image?(new_file)
    new_file.content_type.to_s =~ /^image\/*/
  end
end
