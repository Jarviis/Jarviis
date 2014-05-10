class Api::V1::UsersController < Api::V1::ApiController
  def index
    @users = User.all

    render json: @users
  end

  def search
    @users = User.search(params)

    render json: @users
  end
end
