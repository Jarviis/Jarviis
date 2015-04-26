class Api::V1::AttachmentsController < Api::V1::ApiController
  before_action :set_issue, only: :create
  before_action :set_attachment, only: :destroy

  def create
    attachment = @issue.attachments.new(attachment_params)
    if params[:remote_image_url]
      attachment.remote_filename_url = params[:remote_image_url]
    end

    if attachment.save
      render json: attachment
    else
      render json: { errors: attachment.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    @attachment.destroy

    render json: { status: :destroyed }
  end

  private

  def set_issue
    @issue = Issue.find(params[:id])
  end

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end

  def attachment_params
    params.require(:attachment).permit(:filename)
  end
end
