class Api::V1::SprintsController < Api::V1::ApiController
  before_action :set_sprint, only: [:show, :update, :destroy]

  def show
    render json: @sprint
  end

  def create
    @sprint = Sprint.new(sprint_params)

    if @sprint.save
      render json: @sprint, status: :created
    else
      render json: { errors: @sprint.errors } , status: :uprocessable_entity
    end
  end

  def update
    if @sprint.update(sprint_params)
       render json: @sprint
    else
      render json: { errors: @sprint.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @sprint.destroy

    render json: @sprint, status: :ok
  end

  private

  def set_sprint
    @sprint = Sprint.find(params[:id])
  end

  def sprint_params
    params.require(:sprint).permit(:name, :team_id, :starttime, :endtime)
  end
end
