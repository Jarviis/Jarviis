class Api::V1::ApiController < ActionController::Base
  protect_from_forgery

  respond_to :json
end
