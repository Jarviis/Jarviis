class Api::V1::ApiController < ActionController::Base
  abstract!

  protect_from_forgery with: :null_session

  before_action :authenticate

  respond_to :json

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      @api_user = User.find_by(authentication_token: token)
    end
  end

  def render_unauthorized
    render json: "Bad credentials", status: 401
  end
end
