class Api::V1::IssuesController < Api::V1::ApiController
  before_action :set_issue, only: [:show, :edit, :update, :destroy,
                                   :resolve, :close, :wontfix, :open,
                                   :comments]

  def index
    @issues = Issue.page(params[:page] || 1)

    render json: @issues
  end

  def search
    query = params[:query]

    if query.blank?
      @issues = Issue.all
    else
      query = ElasticsearchQuerySanitizer.sanitize(query)

      @issues = Issue.search(query).page(params[:page] || 1).
        results.to_a
    end

    render json: @issues
  end

  def show
    render json: @issue
  end

  def create
    @issue = Issue.new(issue_params)
    @issue.state = Issue::OPEN
    @issue.reporter_id = @api_user.id

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
    resolve_issue(!!@issue.resolve!)
  end

  def close
    close_issue(!!@issue.close!)
  end

  def wontfix
    @issue.wontfix!

    render json: { status: :wontfix }
  end

  def open
    open_issue(!!@issue.open!)
  end

  def comments
    render json: { comments: @issue.comments, issue_id: @issue.id }
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

  def method_missing(method, *args)
    if method.match(/^(resolve|close|open)_issue$/)
      if args.first
        status = method.to_s.gsub("_issue", "")
        status << "d" if status != "open"
        status = status.to_sym
      else
        errors = "Something was wrong with the state transition you requested"
      end

      if status
        render json: { status: status }
      else
        render json: { errors: errors, status: :unprocessable_entity }
      end
    else
      super(args)
    end
  end
end
