class Api::V1::ApiController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!

  respond_to :json
end
