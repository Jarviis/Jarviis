class Api::V1::TeamsController < Api::V1::ApiController
  def index
    @teams = Team.all

    render json: @team
  end

  def show
    @team = Team.find(params[:id])

    render json: @issue
  end
end
