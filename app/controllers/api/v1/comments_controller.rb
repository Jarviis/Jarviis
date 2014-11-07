class Api::V1::CommentsController < Api::V1::ApiController
  before_action :set_comment, only: :destroy

  def create
    issue = Issue.find(params[:issue_id])
    comment = issue.comments.new(comment_params)
    comment.user_id = @api_user.id


    if comment.save
      render json: comment
    else
      render json: { errors: comment.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    if @comment.user_id == @api_user.id
      @comment.destroy
      render json: { status: :destroyed }
    else
      render json: {}, status: :unauthorized
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
