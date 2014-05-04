class Api::V1::IssuesController < Api::V1::ApiController
  before_action :set_issue, only: [:show, :edit, :update, :destroy,
                                   :resolve, :close, :wontfix, :open]
  def index
    @issues = Issue.page(params[:page] || 1)

    render json: @issues
  end

  def show
    render json: @issue
  end

  def create
    @issue = Issue.new(issue_params)
    @issue.state = Issue::OPEN
    @issue.reporter_id = current_user.id

    if @issue.save
      render json: @issue
    else
      render json: { errors: @issue.errors, status: :unprocessable_entity }
    end
  end

  def update
    if @issue.update(issue_params)
       render json: @issue
    else
      render json: { errors: @issue.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    @issue.destroy

    render json: { status: :destroyed }
  end

  def resolve
    if @issue.resolve!
      render json: { status: :resolved }
    else
      render json: { errors: "Issue##{@issue.id} was not open", status: :unprocessable_entity }
    end
  end

  def close
    if @issue.close!
      render json: { status: :closed }
    else
      render json: { errors: "Issue##{@issue.id} was not open", status: :unprocessable_entity }
    end
  end

  def wontfix
    @issue.wontfix!

    render json: { status: :wontfix }
  end

  def open
    if @issue.open!
      render json: { status: :open }
    else
      render json: { errors: "Issue##{@issue.id} was already open", status: :unprocessable_entity }
    end
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
