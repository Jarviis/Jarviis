class Api::V1::ApiController < ActionController::Base
  abstract!

  protect_from_forgery with: :null_session

  before_action :authenticate

  respond_to :json
end
