class Api::V1::IssuesController < Api::V1::ApiController
  before_action :set_issue, only: [:show, :edit, :update, :destroy]
  def index
    @issues = Issue.search(params)

    render json: @issues
  end

  def show
    render json: @issue
  end

  def create
    @issue = Issue.new(issue_params)
    @issue.state = Issue::OPEN

    if @issue.save
      render json: { status: :created }
    else
      render json: { errors: @issue.errors, status: :unprocessable_entity }
    end
  end

  def update
    if @issue.update(issue_params)
       render json: { status: :updated }
    else
      render json: { errors: @issue.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    @issue.destroy

    render json: { status: :destroyed }
  end

  private

  def set_issue
    @issue = Issue.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(:state, :name,
      :description, :assignee_id, :reporter_id, :due_date,
      :parent_id)
  end
end
